variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
  default     = "0.0.0.0/0" # or replace with IP/32
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default = "OriginalKeyPair"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}