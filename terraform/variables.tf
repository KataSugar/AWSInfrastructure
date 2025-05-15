variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "registry-eks-cluster"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "940482431327"
}

