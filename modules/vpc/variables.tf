variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for the Public Subnet in ap-northeast-1a"
  type        = string
}

variable "public_subnet_c_cidr" {
  description = "CIDR block for the Public Subnet in ap-northeast-1c"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for the Private Subnet in ap-northeast-1a"
  type        = string
}

variable "private_subnet_c_cidr" {
  description = "CIDR block for the Private Subnet in ap-northeast-1c"
  type        = string
}