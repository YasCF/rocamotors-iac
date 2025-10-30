variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC asociada"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets para EKS"
  type        = list(string)
}
