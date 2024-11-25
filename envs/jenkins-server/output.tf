output "jenkins_server_ip" {
  description = "Public IP address of the Jenkins server"
  value       = aws_instance.jenkins-server.public_ip
}

output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${aws_instance.jenkins-server.public_ip}:8080"
}
