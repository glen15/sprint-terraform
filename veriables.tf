variable "region" {
  default     = "ap-northeast-2"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  default     = "abcd1234"
  sensitive   = true
}
