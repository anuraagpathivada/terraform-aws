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


resource "aws_security_group" "allow_all_internal_traffic" {
  name              = "${var.vpc_name}-internal_traffic"
  description       = "ssh traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "All Internal Traffic"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Name = "${var.vpc_name}-internal_traffic"
    "Env_type" = "${var.env_type}"
  }
}