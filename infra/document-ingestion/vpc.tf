# module "vpc" {
#   source = "git@github.com:terraform-aws-modules/terraform-aws-vpc?ref=v6.0.1"

#   name = "law-demo-pdf-vpc"

#   cidr = "10.0.0.0/16"

#   azs             = ["eu-west-1a", "eu-west-1b"]
#   private_subnets = concat(var.data_subnet_cidrs, var.compute_subnet_cidrs)

#   enable_nat_gateway = false
#   single_nat_gateway = false

# #   tags = {
# #     Owner       = "user"
# #     Environment = "dev"
# #   }
# }

