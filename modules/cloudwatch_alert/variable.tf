variable "alert_email" {
  description = "Email to receive CloudWatch alerts"
  type        = string
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "api_stage" {
  description = "Stage name of the API Gateway"
  type        = string
  default     = "$default"
}

variable "api_id" {
  description = "ID of the API Gateway"
  type        = string
}
