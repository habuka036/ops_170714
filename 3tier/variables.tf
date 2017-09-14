provider "aws" {
  region = "ap-northeast-1"
  shared_credentials_file = "/home/osamu/.aws/credentials"
  profile = "gocid"
}

terraform {
  backend "s3" {
    bucket = "osamu-habuka-cicd"
    key = "blue/terraform.tfstate"
    region = "ap-northeast-1"
    shared_credentials_file = "/home/osamu/.aws/credentials"
    profile = "gocid"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "osamu-habuka-cicd"
    key = "blue/terraform.tfstate"
    region = "ap-northeast-1"
    shared_credentials_file = "/home/osamu/.aws/credentials"
    profile = "gocid"
  }
}

variable "amis" {
  default = {
    ubuntu = "ami-785c491f"
    blue = "ami-e30f1484"
    green = "ami-870c17e0"
  }
}

variable "keypair" {
  default = {
    web = "gocid01"
    app = "gocid01"
    db = "gocid01"
  }
}

variable "instance-type" {
  default = {
    web = "t2.medium"
    app = "t2.medium"
    db = "t2.medium"
  }
}

variable "volume_size" {
  default = {
    web = 10
    app = 10
    db = 10
  }
}

variable "environment" {
  default = "blue"
}
