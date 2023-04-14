provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Project = "win-ad-ec2-${var.env}"
      Env     = var.env
    }
  }
}

module "connectable_instance_for_ad" {
    source = "./common_modules/connectable_win_ec2"

    key_name = var.key_name
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.private_subnets[0]

}