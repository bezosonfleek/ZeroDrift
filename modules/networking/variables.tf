variable "project_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidr" {
  type = string
}
variable "availability_zone" {
  type = string
}
variable "allowed_ips" {
  type = list(string)
}