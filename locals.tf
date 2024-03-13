locals {
  vpc_name        = "${var.cluster_name}-vpc"
  newbits         = ceil(log(length(var.azs) * 2, 2))
  private_subnets = [for i in var.azs : cidrsubnet(var.vpc_cidr, local.newbits, index(var.azs, i) * 2)]
  public_subnets  = [for i in var.azs : cidrsubnet(var.vpc_cidr, local.newbits, (index(var.azs, i) * 2) + 1)]
}
