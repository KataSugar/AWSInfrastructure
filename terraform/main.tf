
module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  region            = var.aws_region
  environment       = var.environment
}

module "networking" {
  source           = "./modules/networking"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  ssh_cidr         = var.ssh_cidr
  environment      = var.environment
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  subnet_id         = module.networking.public_subnet_id
  security_group_id = module.networking.security_group_id
  key_name          = var.key_name
  environment       = var.environment
}

# Read server.js file
data "template_file" "server_js" {
 template = file("${path.module}/../server.js")
}



  