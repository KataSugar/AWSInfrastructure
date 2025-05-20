 
 # fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# read server.js file
data "template_file" "server_js" {
  template = file("${path.module}/../../server.js")
  vars = {
    port = 8080
  }
}
 
resource "aws_instance" "backend" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              # Copy server.js to /app
              mkdir -p /app
              cat << 'EOT' > /app/server.js
              ${data.template_file.server_js.template}
              EOT
              # Run data.sh
              ${file("${path.module}/data.sh")}
              EOF

  tags = {
    Name        = "backend-ec2"
    Environment = var.environment
  }
}