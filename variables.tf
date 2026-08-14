variable "project_name" {
  default = "zero-drift"
}

variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "allowed_ips" {
  default = ["197.237.211.90/32"]
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "zero_drift_public_ssh_key" {
  type = string
}