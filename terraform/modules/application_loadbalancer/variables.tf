variable "name" {
  description = "The name of the ALB"
  type        = string
}

variable "tg_name" {
  description = "The name of the ALB target group"
  type        = string
}

variable "listener_name" {
  description = "The name of the ALB listener"
  type        = string
}

variable "target_id" {
  description = "The target ID for the ALB target group attachment"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the ALB"
  type        = string

}

variable "subnet_ids" {
  description = "The subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group" {
  description = "The security group for the ALB"
  type        = any
}

variable "tags" {
  description = "The tags to apply to all resources"
  type        = map(string)
  default     = {}
}

