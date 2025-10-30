variable "log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN del SNS Topic para notificaciones"
  type        = string
}
