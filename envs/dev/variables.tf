variable "key-pair" {
  description = "Key pair for EC2 instance"
  type = string
  default = ""
}

variable "vpc_id" {
  description = "The ID of the VPC to create the security group in"
  type        = string
  default = null
}

variable "cidr_blocks" {
  description = "CIDR blocks for ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "create_ebs" {
  default = true
  description = "Whether to create EBS volumes for the EC2 instances"
}

variable "ebs_volume_size" {
  default = 8
  description = "Size of the EBS volume in GB (ensure it stays within free tier limits)"
}