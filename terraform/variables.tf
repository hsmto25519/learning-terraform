# Variable for EC2 key name
variable "key_name" {
  description = "The key name to use for the EC2 instance"
  type        = string
  # default     = "default-key"
}

# Variable for EC2 instance type
variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  # default     = "t2.micro"
}
