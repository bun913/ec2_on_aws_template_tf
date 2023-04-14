module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  enable_nat_gateway = false
  single_nat_gateway = false

  cidr = "10.30.0.0/16"
  private_subnets = [
    "10.30.10.0/24",
    "10.30.11.0/24",
  ]
  azs = ["ap-northeast-1a", "ap-northeast-1c"]
}

resource "aws_security_group" "allow_inbound_from_vpc" {
  name        = "allow_inbound_from_vpc"
  description = "Allow inbound from vpc"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}

module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.allow_inbound_from_vpc.id]

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      route_table_ids     = module.vpc.private_route_table_ids
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      route_table_ids     = module.vpc.private_route_table_ids
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      route_table_ids     = module.vpc.private_route_table_ids
    },
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
