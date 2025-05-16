output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "public_subnet_id" {
  value = var.public_subnet_id
}