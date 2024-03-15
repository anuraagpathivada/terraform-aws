resource "aws_key_pair" "bastionpublickey" {
  key_name   = "${var.vpc_name}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaCr/qNpj2oER4x+eV2M+/OUwp+qreJrGyEhlKukr5YMSDp53MSwzTnZuLkciXFwI+T0LECw1qZl/HX5bOG+tBuVotdLaYI334lp/kO6KVOOPMojuixQgXm5ZGHq4b5OxR5x+axjxTsi+eB8AaIGBxCrZUa0YJK9RzcxV5fvYmoqyeiraEbCjJBbAyOMetz6SrsvWgg99AtLgC8JhQUlHvf3rqCSu10GZHAPKJOUsYARNX0/2BTFukR3MBbKHhvzZN55t8Mp5A2FXuIrR8ioUB3DSJrBcCQ8MCPGq3hfoWCtTpc1fwKckfOz3fiOYfwA9PX/Qyhw9C6E0S4nvPWVbN"
}

# Launch Template

resource "aws_launch_template" "webapp" {
  name_prefix   = "${var.vpc_name}-"
  depends_on = [ aws_key_pair.bastionpublickey ]
  image_id      = var.ec2_image
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = ["${aws_security_group.allow_all_internal_traffic.id}"]
  # User data script to install required binaries
  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Install Node.js for React app
              curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
              sudo yum install -y nodejs git
              sudo amazon-linux-extras install nginx1 -y

              # Get Git credentials from  file
              git config --global credential.helper '!echo "username=${var.git_username}\npassword=${var.git_password}"'

              # Clone the GitHub repository containing the React app
              git clone https://github.com/anuraagpathivada/terraform-aws.git /tmp/terraform-aws
              sudo chown -R ec2-user:ec2-user /tmp/terraform-aws

              # Copy React app files to appropriate location
              sudo mkdir -p /var/www/html
              sudo cp -r /tmp/terraform-aws/Apps/frontend/practice-sample/* /var/www/html/
              sudo chown -R ec2-user:ec2-user /var/www/html

              # Install dependencies and build the React app
              cd /var/www/html
              npm install
              sudo chown -R ec2-user:ec2-user /var/www/html
              npm install axios
              sudo chown -R ec2-user:ec2-user /var/www/html
              npm run build
              sudo chown -R ec2-user:ec2-user /var/www/html

              # Configure Nginx to serve React app
              sudo rm -f /etc/nginx/nginx.conf  # Remove default nginx config
              sudo cp /tmp/terraform-aws/Apps/frontend/nginx.conf /etc/nginx/nginx.conf  
              sudo systemctl enable nginx
              sudo systemctl restart nginx

              EOF
              )
  key_name = aws_key_pair.bastionpublickey.key_name
  tags = {
    "Env_type" = "${var.env_type}"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}_instance"
    }

  }
}

# Auto Scaling Group

resource "aws_autoscaling_group" "webapp" {
  name                      = "${var.vpc_name}-asg"
  launch_template {
    id      = aws_launch_template.webapp.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns         = [aws_lb_target_group.webapp.arn]
  tag {
    key                 = "Env_type"
    value               = "${var.env_type}"
    propagate_at_launch = true
  }
}

# Create EC2 bastion
 resource "aws_instance" "bastion" {
  depends_on = [ aws_key_pair.bastionpublickey ]
  instance_type = var.ec2_instance_type
  subnet_id = module.vpc.public_subnets[0]
  security_groups = ["${aws_security_group.allow_ec2_ssh_traffic.id}"]
  associate_public_ip_address = true
  ami =  var.ec2_image
  key_name = aws_key_pair.bastionpublickey.key_name

  root_block_device {
    delete_on_termination =  true
    volume_size = "10"
  }

  provisioner "file" {
    source      = "bastionopenssh.pem"
    destination = "/home/ec2-user/bastionopenssh.pem"
    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ec2-user"
      private_key = "${file(var.bastionopenssh)}"
    }
  }

  tags = {
    "Env_type" = "${var.env_type}"
    Name = "${var.vpc_name}-bastion"
  }
 }


# Load Balancer

resource "aws_lb" "webapp" {
  name               = "${var.vpc_name}-lb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.allow_lb_traffic.id]

  tags = {
    Name = "${var.vpc_name}-lb"
    "Env_type" = "${var.env_type}"
  }
}

# Target Group 

resource "aws_lb_target_group" "webapp" {
  name     = "${var.vpc_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/"
  }

  tags = {
    Name = "${var.vpc_name}-tg"
    "Env_type" = "${var.env_type}"
  }
}


# Listener

resource "aws_lb_listener" "webapp" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}