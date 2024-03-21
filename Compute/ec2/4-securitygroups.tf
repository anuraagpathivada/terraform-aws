# Allow ssh traffic to Bastion

resource "aws_security_group" "allow_ec2_ssh_traffic" {
  name              = "${var.vpc_name}-ssh_bastion"
  description       = "ssh traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH Traffic"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = "${var.vpc_name}-ssh_bastion"
    "Env_type" = "${var.env_type}"
  }
}


# Allow ssh traffic from Bastion to servers

resource "aws_security_group" "allow_bastion_ec2_ssh_traffic" {
  name              = "${var.vpc_name}-ssh_bastion_ec2"
  description       = "ssh traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH Traffic"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.allow_ec2_ssh_traffic.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = "${var.vpc_name}-ssh_bastion_ec2"
    "Env_type" = "${var.env_type}"
  }
}

resource "aws_security_group" "allow_internet_alb_traffic" {
  name        = "${var.vpc_name}-alb-internet"
  description = "Allow internet traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.vpc_name}-alb-internet"
    "Env_type" = "${var.env_type}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP_redirection" {
  security_group_id = aws_security_group.allow_internet_alb_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group" "allow_alb_backend_traffic" {
  name        = "${var.vpc_name}-backend-sg"
  description = "Traffic from ALB to backend instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_internet_alb_traffic.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.vpc_name}-backend-sg"
    "Env_type" = "${var.env_type}"
  }
}

resource "aws_security_group" "allow_alb_frontend_traffic" {
  name        = "${var.vpc_name}-frontend-sg"
  description = "Traffic from ALB to Frontend instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_internet_alb_traffic.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.vpc_name}-backend-sg"
    "Env_type" = "${var.env_type}"
  }
}