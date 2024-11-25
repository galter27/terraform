output "jenkins_server_ip" {
  description = "Public IP address of the Jenkins server"
  value       = aws_instance.jenkins-server.public_ip
}

output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${aws_instance.jenkins-server.public_ip}:8080"
}

output "jenkins_admin_token" {
  description = "Jenkins initial admin password"
  value       = chomp(file("${path.module}/jenkins_token.txt"))
  sensitive = false
}
