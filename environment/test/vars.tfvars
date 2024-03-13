aws_region = "sa-east-1"
azs        = ["sa-east-1a", "sa-east-1b"]
vpc_cidr   = "10.0.0.0/24"

cluster_name           = "teste-zava"
kubernetes_version     = "1.28"
node_capacity_type     = "SPOT"
node_instance_type     = "t2.micro"
nodes_desired_capacity = 3
nodes_min_capacity     = 3
nodes_max_capacity     = 3
