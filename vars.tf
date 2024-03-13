variable "aws_region" {
  description = "Região da aws onde os recursos serão provisionados"
  type        = string
}

# vpc
variable "azs" {
  description = "Lista das zonas de disponibilidade que serão utilizadas na criação dos recursos"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "Bloco cidr da vpc"
  type        = string
}

# eks
variable "cluster_name" {
  description = "Nome do cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do kubernetes"
  type        = string
}

variable "node_instance_type" {
  description = "Tipo da instância de cada nó"
  type        = string
}

variable "nodes_desired_capacity" {
  description = "Número de nós desejado"
  type        = number
}

variable "nodes_min_capacity" {
  description = "Número mínimo de nós"
  type        = number
}

variable "nodes_max_capacity" {
  description = "Número máximo de nós"
  type        = number
}
