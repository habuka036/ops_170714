
module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "threetier"

  cidr = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  enable_nat_gateway = "true"

  azs      = ["ap-northeast-1a", "ap-northeast-1c"]

  tags {
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }
}

module "sg_web" {
  source = "github.com/habuka036/tf_aws_sg?ref=gocid//sg_web"
  security_group_name = "web"
  vpc_id = "${module.vpc.vpc_id}"
  source_cidr_block = ["0.0.0.0/0"]
}

module "ec2_instance_web" {
  source = "github.com/habuka036/tf_aws_ec2_instance?ref=rotate_subnet"
  instance_type = "${var.instance-type["web"]}"
  instance_name = "web"
  ami_id = "${var.amis["blue"]}"
  subnet_ids = ["${module.vpc.public_subnets}"]
  number_of_instances = 2
  user_data = ""
  security_groups = ["${module.sg_web.security_group_id_web}"]
  key_name = "gocid01"
}

module "ec2_instance_app" {
  source = "github.com/habuka036/tf_aws_ec2_instance?ref=rotate_subnet"
  instance_type = "${var.instance-type["app"]}"
  instance_name = "app"
  ami_id = "${var.amis["ubuntu"]}"
  subnet_ids = ["${module.vpc.private_subnets}"]
  number_of_instances = 2
  user_data = ""
  key_name = "gocid01"
}

#module "ec2_instance_db" {
#  source = "github.com/habuka036/tf_aws_ec2_instance?ref=rotate_subnet"
#  instance_type = "${var.instance-type["db"]}"
#  instance_name = "db"
#  ami_id = "${var.amis["ap-northeast-1"]}"
#  subnet_ids = ["${module.vpc.database_subnets}"]
#  number_of_instances = 2
#  user_data = ""
#}

module "elb_http" {
  source = "github.com/habuka036/tf_aws_elb?ref=gocid//elb_http"
  elb_name = "threetier"
  subnet_az1 = "${module.vpc.public_subnets[0]}"
  subnet_az2 = "${module.vpc.public_subnets[1]}"
  elb_security_group = "${module.sg_web.security_group_id_web}"
  backend_port = "80"
  backend_protocol = "http"
  health_check_target = "HTTP:80/"
  instances = ["${module.ec2_instance_web.ids}"]
}

resource "aws_route53_record" "www" {
  zone_id = "Z2EJVI7C3O26H1"
  name = "www"
  type = "CNAME"
  ttl = 30
  records = ["${module.elb_http.elb_dns_name}"]
}

