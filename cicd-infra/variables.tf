provider "aws" {
  region = "ap-northeast-1"
  shared_credentials_file = "/home/osamu/.aws/credentials"
  profile = "gocid"
}

variable "amis" {
  default = {
    ap-northeast-1 = "ami-785c491f"
  }
}

variable "keypair" {
  default = {
    gogs = "gocid01"
    drone = "gocid01"
  }
}

variable "instance-type" {
  default = {
    gogs = "t2.medium"
    drone = "t2.medium"
  }
}

variable "subnet_ids" {
  default = {
    gogs = "subnet-2fcac659"
    drone = "subnet-2fcac659"
  }
}

variable "sg_ids" {
  default = {
    gogs = "sg-29dc724f"
    drone = "sg-29dc724f"
  }
}

variable "volume_size" {
  default = {
    gogs = 10
    drone = 10
  }
}

variable "eip_allocation_ids" {
  default = {
    gogs = "eipalloc-117bd375"
    drone = "eipalloc-0748e063"
  }
}

variable "drone_secret" {}
variable "drone_host" {}
variable "gogs_host" {}
variable "ssh_user" {}
variable "ssh_private_key" {}

