variable "key_name" {
  description = "The key name to use for the EC2 instance"
  type        = string
  # default     = "default-key"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}
