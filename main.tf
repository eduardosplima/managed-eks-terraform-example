module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway      = true
  single_nat_gateway      = false
  enable_dns_support      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  public_subnet_tags = {
    # Necessário para a criação do load balancer ao criar um ingress
    "kubernetes.io/role/elb" = "1"
  }

  tags = {
    Name = local.vpc_name
  }
}

module "eks" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/eks/aws"
  version    = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  eks_managed_node_groups = {
    nodes = {
      name = "${var.cluster_name}-nodes"

      desired_size   = var.nodes_desired_capacity
      instance_types = [var.node_instance_type]
      min_size       = var.nodes_min_capacity
      max_size       = var.nodes_max_capacity
      capacity_type  = var.node_capacity_type

      subnets = module.vpc.private_subnets
    }
  }

  # Adiciona o executor do terraform como admin do cluster
  enable_cluster_creator_admin_permissions = true

  # Como é teste, tá público rsrsrs
  cluster_endpoint_public_access = true
}
