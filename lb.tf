resource "aws_lb" "jh-lb" {
  name               = "jh-terraform-asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jh-public-sg.id]
  subnets            = [aws_subnet.jh-private-subnet-1.id, aws_subnet.jh-private-subnet-2.id]
}

resource "aws_lb_target_group" "jh-terraform-asg-lb-target-group" {
  name     = "jh-terraform-asg-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.jh-vpc.id
}

resource "aws_lb_listener" "jh-terraform-asg-lb-listener" {
  load_balancer_arn = aws_lb.jh-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jh-terraform-asg-lb-target-group.arn
  }
}

# resource "aws_autoscaling_attachment" "jh-terraform-asg-asg-attachment" {
#   autoscaling_group_name = module.asg.jh-terraform-asg.id
#   alb_target_group_arn   = aws_lb_target_group.jh-terraform-asg-lb-target-group.arn
# }
