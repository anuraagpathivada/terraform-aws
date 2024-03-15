
resource "aws_key_pair" "bastionpublickey" {
  key_name   = "${var.vpc_name}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaCr/qNpj2oER4x+eV2M+/OUwp+qreJrGyEhlKukr5YMSDp53MSwzTnZuLkciXFwI+T0LECw1qZl/HX5bOG+tBuVotdLaYI334lp/kO6KVOOPMojuixQgXm5ZGHq4b5OxR5x+axjxTsi+eB8AaIGBxCrZUa0YJK9RzcxV5fvYmoqyeiraEbCjJBbAyOMetz6SrsvWgg99AtLgC8JhQUlHvf3rqCSu10GZHAPKJOUsYARNX0/2BTFukR3MBbKHhvzZN55t8Mp5A2FXuIrR8ioUB3DSJrBcCQ8MCPGq3hfoWCtTpc1fwKckfOz3fiOYfwA9PX/Qyhw9C6E0S4nvPWVbN"
}

# Launch Template

resource "aws_launch_template" "demo" {
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
              sudo yum install -y nodejs nginx

              # Install Python and Flask for Flask app
              sudo yum install -y python3 python3-pip
              pip3 install flask flask-cors

              # Add any additional commands to set up your applications here
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

resource "aws_autoscaling_group" "demo" {
  name                      = "${var.vpc_name}-asg"
  launch_template {
    id      = aws_launch_template.demo.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets
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


