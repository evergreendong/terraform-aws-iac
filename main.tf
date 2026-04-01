terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-louis"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.2.0/24"
  az_1                 = "us-east-1a"
  az_2                 = "us-east-1b"
}

module "compute" {
  source = "./modules/compute"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_ids[0]
}

module "database" {
  source            = "./modules/database"
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = "sg-0e6271b6acca61d5e"
  db_name           = "appdb"
  db_username       = "admin"
  db_password       = "password123"
}