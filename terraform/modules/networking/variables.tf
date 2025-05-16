variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
  default     = "0.0.0.0/0" # Override in main.tf for security
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}