resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = var.log_group_name
  retention_in_days = 7
  tags = {
    Project = "roca"
  }
}

# Ejemplo: Alarma de CPU alta
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "roca-eks-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarma de CPU > 80%"
  alarm_actions       = [var.sns_topic_arn]
}

