### Shared
variable "tags" {
  description = "The tags to apply to all resources"
  type        = map(string)
  default     = {}
}

### Network
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR blocks for my VPC"
  type = object({
    base = string
    subnet = object({
      public  = map(object({ cidr = string, az = string }))
      private = map(object({ cidr = string, az = string }))
    })
  })
}

variable "sg" {
  description = "The name of the security group"
  type        = any
}

variable "igw_name" {
  description = "The name of the internet gateway"
  type        = string
}

variable "rt_name" {
  description = "The name of the route table"
  type        = string
}

### ALB
variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "alb_tg_name" {
  description = "The name of the ALB target group"
  type        = string
}

variable "alb_listener_name" {
  description = "The name of the ALB listener"
  type        = string
}

### EC2
variable "ec2_name" {
  description = "The name of the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}
