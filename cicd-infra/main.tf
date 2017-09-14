
resource "aws_instance" "gogs" {
  ami                         = "${var.amis["ap-northeast-1"]}"
  availability_zone           = "ap-northeast-1a"
  ebs_optimized               = false
  instance_type               = "${var.instance-type["gogs"]}"
  monitoring                  = false
  key_name                    = "${var.keypair["gogs"]}"
  subnet_id                   = "${var.subnet_ids["gogs"]}"
  vpc_security_group_ids      = ["${var.sg_ids["gogs"]}"]
  associate_public_ip_address = true
  source_dest_check           = true
  iam_instance_profile        = "cicd"
  root_block_device {
        volume_type           = "gp2"
        volume_size           = "${var.volume_size["gogs"]}"
        delete_on_termination = true
    }
    tags {
        "Name" = "gogs"
    }
}

resource "aws_instance" "drone" {
  ami                         = "${var.amis["ap-northeast-1"]}"
  availability_zone           = "ap-northeast-1a"
  ebs_optimized               = false
  instance_type               = "${var.instance-type["drone"]}"
  monitoring                  = false
  key_name                    = "${var.keypair["drone"]}"
  subnet_id                   = "${var.subnet_ids["drone"]}"
  vpc_security_group_ids      = ["${var.sg_ids["drone"]}"]
  associate_public_ip_address = true
  source_dest_check           = true
  iam_instance_profile        = "cicd"
  root_block_device {
        volume_type           = "gp2"
        volume_size           = "${var.volume_size["drone"]}"
        delete_on_termination = true
    }
    tags {
        "Name" = "drone"
    }
}

resource "aws_eip_association" "gogs" {
  instance_id = "${aws_instance.gogs.id}"
  allocation_id = "${var.eip_allocation_ids["gogs"]}"
}

resource "aws_eip_association" "drone" {
  instance_id = "${aws_instance.drone.id}"
  allocation_id = "${var.eip_allocation_ids["drone"]}"
}

module "gogs" {
  source = "../modules/gogs/"
  gogs_host = "${var.gogs_host}"
  ssh_user = "${var.ssh_user}"
  ssh_private_key = "${var.ssh_private_key}"
} 

module "drone" {
  source = "../modules/drone/"
  drone_secret = "${var.drone_secret}"
  drone_host = "${var.drone_host}"
  gogs_host = "${var.gogs_host}"
  ssh_user = "${var.ssh_user}"
  ssh_private_key = "${var.ssh_private_key}"
} 


