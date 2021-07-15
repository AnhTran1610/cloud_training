resource "aws_lb_target_group_attachment" "web_service_group" {
  count            = length(aws_instance.webserver_ahta)
  target_group_arn = aws_lb_target_group.web_service_group.arn
  target_id        = aws_instance.webserver_ahta[count.index].id
  port             = 80
}