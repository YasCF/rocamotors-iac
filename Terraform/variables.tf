variable "aws_access_key" {
  description = "Access key temporal del AWS Academy Lab"
  type        = string
}

variable "aws_secret_key" {
  description = "Secret key temporal del AWS Academy Lab"
  type        = string
}

variable "aws_session_token" {
  description = "Session token temporal del AWS Academy Lab"
  type        = string
}

variable "project" {
  description = "Prefijo del proyecto"
  default     = "roca"
}

variable "region" {
  description = "Región AWS"
  default     = "us-east-1"
}
