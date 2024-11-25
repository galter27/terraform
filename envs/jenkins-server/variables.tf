variable "private_key_name" {
  description = "The name of the private SSH key to use for the instance"
  type        = string
}

variable "private_key_file" {
  description = "The name of the private SSH key to use for the instance"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the Jenkins server"
  type        = string
  default = "ami-0e402a5891340c3c2" # Ubuntu Image
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
  default     = "t3.micro"
}
