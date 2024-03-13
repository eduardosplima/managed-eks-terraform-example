variable "aws_region" {
  description = "Região da aws onde os recursos serão provisionados"
  type        = string
  default     = "sa-east-1"
}

# vpc
variable "azs" {
  description = "Lista das zonas de disponibilidade que serão utilizadas na criação dos recursos"
  type        = list(string)
  default     = ["sa-east-1a", "sa-east-1b"]
}

variable "vpc_cidr" {
  description = "Bloco cidr da vpc"
  type        = string
  default     = "10.0.0.0/24"
}

# eks
variable "cluster_name" {
  description = "Nome do cluster"
  type        = string
  default     = "testes-lorran"
}

variable "kubernetes_version" {
  description = "Versão do kubernetes"
  type        = string
  default     = "1.28"
}

variable "node_instance_type" {
  description = "Tipo da instância de cada nó"
  type        = string
  default     = "t3.large"
}

variable "node_capacity_type" {
  description = "Tipo de capacidade dos nós (ON_DEMAND, SPOT)"
  type        = string
  default     = "SPOT"

  validation {
    condition = contains([
      "ON_DEMAND", # Implementa um s3 tradicional, que deverá ser acessado via sdk com access key
      "SPOT"       # Implementa um servidor sftp (aws transfer) utizando um bucket s3 como storage
    ], var.node_capacity_type)
    error_message = "Defina um tipo de capacidade válido (ON_DEMAND ou SPOT)"
  }
}

variable "nodes_desired_capacity" {
  description = "Número de nós desejado"
  type        = number
  default     = 2
}

variable "nodes_min_capacity" {
  description = "Número mínimo de nós"
  type        = number
  default     = 2
}

variable "nodes_max_capacity" {
  description = "Número máximo de nós"
  type        = number
  default     = 2
}
