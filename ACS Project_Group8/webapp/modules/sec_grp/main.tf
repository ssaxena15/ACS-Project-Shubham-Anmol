# sec_grp module: main.tf

# --- ALB security group
resource "aws_security_group" "web_alb_sg" {
    vpc_id = var.aws_vpc_id
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["10.100.2.34/32"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# --- Allow SSH to bastion host
resource "aws_security_group" "allow_ssh_bastion" {
  name = "allow_ssh_bastion"
  vpc_id = var.aws_vpc_id
  
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
   cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-allow_ssh_bastion"
  }
  
}

# -- Internal SSH connection
resource "aws_security_group" "allow_ssh_internal" {
  name = "allow_ssh_internal"
  vpc_id = var.aws_vpc_id

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["10.1.2.34/32"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-allow_ssh_internal"
  }

}