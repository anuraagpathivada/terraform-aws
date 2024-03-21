
resource "aws_key_pair" "bastionpublickey" {
  key_name   = "${var.vpc_name}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaCr/qNpj2oER4x+eV2M+/OUwp+qreJrGyEhlKukr5YMSDp53MSwzTnZuLkciXFwI+T0LECw1qZl/HX5bOG+tBuVotdLaYI334lp/kO6KVOOPMojuixQgXm5ZGHq4b5OxR5x+axjxTsi+eB8AaIGBxCrZUa0YJK9RzcxV5fvYmoqyeiraEbCjJBbAyOMetz6SrsvWgg99AtLgC8JhQUlHvf3rqCSu10GZHAPKJOUsYARNX0/2BTFukR3MBbKHhvzZN55t8Mp5A2FXuIrR8ioUB3DSJrBcCQ8MCPGq3hfoWCtTpc1fwKckfOz3fiOYfwA9PX/Qyhw9C6E0S4nvPWVbN"
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


# Launch Template for webapp

resource "aws_launch_template" "webapp" {
  name_prefix   = "${var.vpc_name}-webapp-"
  depends_on = [ aws_key_pair.bastionpublickey ]
  image_id      = var.ec2_image
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = ["${aws_security_group.allow_alb_frontend_traffic.id}", "${aws_security_group.allow_bastion_ec2_ssh_traffic.id}"]
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
              sudo cp -r /tmp/terraform-aws/Apps/Client-Side-Rendering/frontend/practice-sample/* /var/www/html/
              sudo cp /tmp/terraform-aws/Apps/Client-Side-Rendering/frontend/practice-sample/.env /var/www/html/
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
              sudo cp /tmp/terraform-aws/Apps/Client-Side-Rendering/frontend/nginx.conf /etc/nginx/nginx.conf  
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
      Name = "${var.vpc_name}_instance-web"
    }

  }
}

# Auto Scaling Group for webapp

resource "aws_autoscaling_group" "webapp" {
  name                      = "${var.vpc_name}-asg-webapp"
  launch_template {
    id      = aws_launch_template.webapp.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns         = [aws_lb_target_group.tg_webapp.arn]
  tag {
    key                 = "Env_type"
    value               = "${var.env_type}"
    propagate_at_launch = true
  }
}

# Launch Template for Backend

resource "aws_launch_template" "backend" {
  name_prefix   = "${var.vpc_name}-backend-"
  depends_on = [ aws_key_pair.bastionpublickey ]
  image_id      = var.ec2_image
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = ["${aws_security_group.allow_alb_backend_traffic.id}", "${aws_security_group.allow_bastion_ec2_ssh_traffic.id}"]
  # User data script to install required binaries
  user_data = base64encode(<<-EOF
              #!/bin/bash
              
              sudo yum install -y git
              pip3 install Flask flask-cors

              # Get Git credentials from  file
              git config --global credential.helper '!echo "username=${var.git_username}\npassword=${var.git_password}"'

              # Clone the GitHub repository containing the React app
              git clone https://github.com/anuraagpathivada/terraform-aws.git /tmp/terraform-aws
              sudo chown -R ec2-user:ec2-user /tmp/terraform-aws

              # Copy Backend app files to appropriate location

              sudo cp -r /tmp/terraform-aws/Apps/Client-Side-Rendering/backend/* /home/ec2-user/
              sudo chown -R ec2-user:ec2-user /home/ec2-user/*

              python3 /home/ec2-user/app.py

              EOF
              )
  key_name = aws_key_pair.bastionpublickey.key_name
  tags = {
    "Env_type" = "${var.env_type}"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}_instance-backend"
    }

  }
}


# Auto Scaling Group for Backend

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.vpc_name}-asg"
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  target_group_arns         = [aws_lb_target_group.tg_backend.arn]
  tag {
    key                 = "Env_type"
    value               = "${var.env_type}"
    propagate_at_launch = true
  }
}

# Application Load Balancer

resource "aws_lb" "app_alb" {
  name               = "${var.vpc_name}-app-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.allow_internet_alb_traffic.id]

  tags = {
    Name     = "${var.vpc_name}-app-alb"
    "Env_type" = "${var.env_type}"
  }
}

# Target Group for the React Frontend

resource "aws_lb_target_group" "tg_webapp" {
  name     = "${var.vpc_name}-tg-webapp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    path    = "/"
    port    = "80"
    protocol= "HTTP"
  }

  tags = {
    Name     = "${var.vpc_name}-tg-webapp"
    "Env_type" = "${var.env_type}"
  }
}

# Target Group for the Flask Backend

resource "aws_lb_target_group" "tg_backend" {
  name     = "${var.vpc_name}-tg-backend"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    path    = "/health" # Ensure your Flask app has a /health endpoint
    port    = "5000"
    protocol= "HTTP"
  }

  tags = {
    Name     = "${var.vpc_name}-tg-backend"
    "Env_type" = "${var.env_type}"
  }
}

# Listener for the ALB: Forward traffic to the React Frontend Target Group by default#
#resource "aws_lb_listener" "front_listener" {
#  load_balancer_arn = aws_lb.app_alb.arn
#  port              = 80
#  protocol          = "HTTP"
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.tg_webapp.arn
#  }
#}

# Listener for the ALB: Forward traffic to the React Frontend Target Group by default

resource "aws_lb_listener" "https_front_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_webapp.arn
  }
}

# Listener Rule for routing /api requests to the Flask Backend

resource "aws_lb_listener_rule" "api_routing" {
  listener_arn = aws_lb_listener.https_front_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# Redirect All HTTP traffic to HTTPS

resource "aws_lb_listener" "http_redirect_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



# Listener Rule for routing /api requests to the Flask Backend
#resource "aws_lb_listener_rule" "api_routing" {
#  listener_arn = aws_lb_listener.front_listener.arn
#  priority     = 100
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.tg_backend.arn
#  }
#  condition {
#    path_pattern {
#      values = ["/api/*"]
#    }
#  }
#}
