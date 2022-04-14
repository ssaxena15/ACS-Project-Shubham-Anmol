terraform {
  backend "s3" {
    encrypt = true
    # cannot contain interpolations
    bucket = "project-web2tier-tf-state-storage"
    
    region = "us-east-1"
    dynamodb_table = "tf-locks"
    key = "tf/s3/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
  #access_key = var.access_key
  #secret_key = var.secret_key
}

# Terraform state S3 storage
#module "TF-State-S3" {
#  source = "./modules/tf_state"
#}

# Module to deploy basic networking 
module "My-VPC" {
  source = "./modules/aws_vpc2"
  env    = var.env
  region = var.region
}

module "Security-Grp" {
  source  = "./modules/sec_grp"
  aws_vpc_id = "${module.My-VPC.my_vpc_id}"
  prefix = "${module.My-VPC.prefix}"
  depends_on = [module.My-VPC]
}

module "AWS-EC2" {
  source  = "./modules/aws_ec2"
  private_subnet_1 = "${module.My-VPC.private_subnet_1}"
  public_subnet_1 = "${module.My-VPC.public_subnet_1}"
  public_subnet_2 = "${module.My-VPC.public_subnet_2}"
  availability_zones_1 = "${module.My-VPC.availability_zones_1}"
  availability_zones_2 = "${module.My-VPC.availability_zones_2}"
  allow_ssh_bastion = "${module.Security-Grp.allow_ssh_bastion}"
  web_alb_sg = "${module.Security-Grp.web_alb_sg}"
  prefix = "${module.My-VPC.prefix}"
  depends_on = [module.My-VPC]
}

module "Target-Grp" {
  source  = "./modules/target_grp"
  aws_vpc_id = "${module.My-VPC.my_vpc_id}"
  prefix = "${module.My-VPC.prefix}"
  aws_lb_arn = "${module.AWS-ALB.aws_lb_arn}"
  depends_on = [module.My-VPC]
}

module "AWS-ALB" {
  source  = "./modules/aws_alb"
  aws_vpc_id = "${module.My-VPC.my_vpc_id}"
  priv_subnet_ids = "${module.My-VPC.private_subnet_ids}"
  pub_subnet_ids = "${module.My-VPC.public_subnet_ids}"
  web_alb_sg = "${module.Security-Grp.web_alb_sg}"
  web_alb_tg_arn = "${module.Target-Grp.web_alb_tg_arn}"
  template_ami = "${module.AWS-EC2.template_ami}"
  #web_lb_launch_config = "${module.AWS-EC2.web_lb_launch_config}"
  prefix = "${module.My-VPC.prefix}"
  depends_on=[ module.My-VPC, module.Security-Grp, module.AWS-EC2] #, module.Target-Grp ]
}


#------------------



