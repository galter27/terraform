output "k8s_node1_id" {
  description = "The ID of the first Kubernetes node EC2 instance"
  value       = aws_instance.k8s_node1.id
}

output "k8s_node2_id" {
  description = "The ID of the second Kubernetes node EC2 instance"
  value       = aws_instance.k8s_node2.id
}

output "k8s_node1_public_ip" {
  description = "The public IP address of the first Kubernetes node"
  value       = aws_instance.k8s_node1.public_ip
}

output "k8s_node2_public_ip" {
  description = "The public IP address of the second Kubernetes node"
  value       = aws_instance.k8s_node2.public_ip
}

output "k8s_sg_id" {
  description = "The ID of the Kubernetes Security Group"
  value       = aws_security_group.k8s_sg.id
}

output "ec2_role_name" {
  description = "The name of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_instance_profile_name" {
  description = "The name of the IAM instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "k8s_policy_arn" {
  description = "The ARN of the Kubernetes IAM policy"
  value       = aws_iam_policy.k8s_policy.arn
}

output "ec2_key_pair_name" {
  description = "The name of the EC2 key pair used"
  value       = "terraform-key"
}
