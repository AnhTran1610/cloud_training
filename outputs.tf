output "Amazon_Linux_2_AMI" {
  description = "Amazon Linux 2 AMI"
  value       = aws_instance.webserver_instances[0].ami
}