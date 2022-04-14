# aws_ec2 module: main.tf

resource "aws_instance" "bastion" {
  ami = "ami-0c293f3f676ec4f90"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_2
  
  availability_zone = var.availability_zones_2
  associate_public_ip_address = "true"
  
  private_ip = "10.30.2.34" #prod

  tags = {
    Name = "${var.prefix}-Bastion"
    name = "Bastion-Host"
  }
  key_name = "shubhamkey"
 
  security_groups = [var.allow_ssh_bastion]

  user_data = file("${path.module}/startscript.sh")
}

resource "aws_ami_from_instance" "web_template_ami" {
  name = "${var.prefix}-ami"
  source_instance_id = aws_instance.bastion.id
  depends_on = [aws_instance.bastion]
}
