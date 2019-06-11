variable "access_key"{}
variable "secret_key"{}
variable "aws_region" {}
variable "dev_instance_type" {}
variable "dev_ami" {}
variable "cidrs_subnet1" {}
variable "cidrs_subnet2" {}
variable "cidrs" {
  type = "map"
}

