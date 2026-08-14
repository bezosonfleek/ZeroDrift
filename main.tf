terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "networking" {
  source             = "./modules/networking"
  project_name       = var.project_name
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  vpc_cidr           = var.vpc_cidr
  allowed_ips        = var.allowed_ips
}

module "compute" {
  source                    = "./modules/compute"
  project_name              = var.project_name
  instance_type             = var.instance_type
  security_group_id         = module.networking.security_group_id
  subnet_id                 = module.networking.subnet_id
  zero_drift_public_ssh_key = var.zero_drift_public_ssh_key
}

