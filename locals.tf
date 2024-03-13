locals {
  vpc_name        = "${var.cluster_name}-vpc"
  private_subnets = [for i in var.azs : cidrsubnet(var.vpc_cidr, 8, index(var.azs, i) + length(var.azs))]
  public_subnets  = [for i in var.azs : cidrsubnet(var.vpc_cidr, 8, index(var.azs, i))]
}
  
