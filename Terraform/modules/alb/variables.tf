variable "vpc_id" {
  description = "ID de la VPC donde se crea el ALB"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets públicas donde estará el ALB"
  type        = list(string)
}
