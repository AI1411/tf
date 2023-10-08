terraform {
  required_version = ">= 1.0.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.65.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "my_vpc" {
  source                = "../../modules/vpc"
  cidr_block            = "10.0.0.0/16"
  vpc_name              = "my_vpc_name"
  public_subnet_a_cidr  = "10.0.1.0/24"
  public_subnet_c_cidr  = "10.0.2.0/24"
  private_subnet_a_cidr = "10.0.3.0/24"
  private_subnet_c_cidr = "10.0.4.0/24"
}

locals {
  # 共通設定
  my_account_id      = "812734177240"
  env                = "dev"
  region             = "ap-northeast-1"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]

  # rds 関連
  rds_instance_class = "db.t3.micro"
}
