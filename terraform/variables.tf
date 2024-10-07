variable "key_name" {
  description = "The key name to use for the EC2 instance"
  type        = string
  # default     = "default-key"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR blocks for my VPC"
  type = object({
    base = string
    subnet = object({
      public  = map(string)
      private = map(string)
    })
  })
}
