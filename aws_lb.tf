resource "aws_lb" "web-lb" {
  name                       = "web-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = aws_subnet.public.*.id
  drop_invalid_header_fields = true

  #   enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Owner = "ahta"
    Name  = "web_lb"
  }
}