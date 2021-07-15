output "Amazon_Linux_2_AMI" {
  description = "Using AMI: "
  value       = aws_instance.webserver_instances[0].ami
}

output "Load_Balance_DNS" {
  description = "Load_Balance_DNS"
  value       = aws_lb.web-lb.dns_name
}