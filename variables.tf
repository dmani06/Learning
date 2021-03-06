# VPC variables
variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}
variable "aws_region" {
  default = "us-east-2"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = " When default instance launched into VPC runs on shared hardware, unless explicitly specified during launch."
  default     = "default"
}

variable "pub_cidr_blocks" {
  description = "A list of public subnet cidr blocks"
  default     = []
}


variable "pri_cidr_blocks" {
  description = "A list of private subnet cidr blocks"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC."
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC."
  default     = []
}

variable "azs" {
  description = "a list of availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = " default is set to true as we want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "default is set to true as we want to use private DNS within the VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "default is set to true as we want to auto-assign public IP on launch"
  default     = true
}
