provider "aws" {
  region = "us-west-2"
}

module "network" {
  source = "./modules/network"
}

module "ec2_config" {
  source = "./modules/ec2_config"
  subnet1 = module.network.subnet1
  subnet2 = module.network.subnet2
  ssh_key = module.ssh_key
  main_security_group = module.network.main_security_group
}

module "dns_dhcp" {
  source = "./modules/dns_dhcp"
  main_vpc = module.network.main_vpc
  instance_1_name = module.ec2_config.instance1_name
  instance_2_name = module.ec2_config.instance2_name
  instance_1_private_ip = module.ec2_config.instance1_private_ip
  instance_2_private_ip = module.ec2_config.instance2_private_ip
}

module "ssh_key" {
  source       = "git::https://gitlab.com/acit_4640_library/tf_modules/aws_ssh_key_pair.git"
  ssh_key_name = "acit_4640_lab_13"
  output_dir   = path.root
}

module "connect_script" {
  source           = "git::https://gitlab.com/acit_4640_library/tf_modules/aws_ec2_connection_script.git"
  ec2_instances    = { "i1" = module.ec2_config.instance1, "i2" = module.ec2_config.instance2 }
  output_file_path = "${path.root}/connect_vars.sh"
  ssh_key_file     = module.ssh_key.priv_key_file
  ssh_user_name    = "ubuntu"
}
