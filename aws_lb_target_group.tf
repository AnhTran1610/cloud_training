resource "aws_lb_target_group" "web_service_group" {
  name     = "web-service-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
  tags = {
    Owner = "ahta"
  }
}