resource "aws_lb_listener" "webservice" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_service_group.arn
  }
  tags = {
    Owner = "huyy"
  }
}