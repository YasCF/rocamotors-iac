resource "aws_sns_topic" "alerts" {
  name = var.topic_name
  tags = {
    Project = "roca"
  }
}

# Ejemplo: suscripción por email (tendrás que confirmar el correo)
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

