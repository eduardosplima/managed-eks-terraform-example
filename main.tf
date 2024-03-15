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

####  Instalação EBS Add-on
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# resource "aws_iam_openid_connect_provider" "eks_cluster_oidc" {
#   depends_on = [module.eks]

#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [module.eks.cluster_tls_certificate_sha1_fingerprint]
#   url             = module.eks.cluster_oidc_issuer_url

#   tags = {
#     Name = "${var.cluster_name}-oidc"
#   }
# }

module "irsa-ebs-csi" {
  depends_on = [module.eks]
  source     = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version    = "4.7.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-ebs-role"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn

  tags = {
    Name = "${var.cluster_name}-ebs-csi"

    eks_addon = "ebs-csi"
    terraform = "true"
  }
}
