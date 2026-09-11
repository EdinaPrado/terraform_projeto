module "network" {
  source = "./modules/network"

  name_prefix        = local.name_prefix
  vpc_cidr           = "10.18.0.0/16"
  public_subnet_cidr = "10.18.1.0/24"
  availability_zone  = "${var.aws_region}a"
}

module "compute" {
  source = "./modules/compute"

  name_prefix   = local.name_prefix
  ami_id        = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_id
  vpc_id        = module.network.vpc_id
}
  