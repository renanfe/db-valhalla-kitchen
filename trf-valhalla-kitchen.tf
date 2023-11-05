provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "vpc-valhalla-kitchen"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "valhalla-kitchen"

  engine            = "postgres"
  engine_version    = "15.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "dbvalhallakitchen"
  username = "testeFiapNaoFacaIssoEmPrd"
  password = "valhalla_kitchen"
  port     = "5432"

  iam_database_authentication_enabled = true

  parameter_group_name = "default"
  family = "postgres15"

  create_db_subnet_group = true
  subnet_ids             = module.vpc.public_subnets

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}