output "Amazon_Linux_2_AMI" {
  description = "Amazon Linux 2 AMI"
  value       = aws_instance.web_server.ami
}