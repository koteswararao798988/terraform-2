# creating external load balancer
resource "aws_lb" "external-alb" {
  name = "ext-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.demosg.id}"]
  subnets = [aws_subnet.public_subnet-1.id,aws_subnet.public_subnet-2.id]
}
resource "aws_lb_target_group" "target-elb" {
  name = "ALB-TG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.demovpc.id
}
resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id = aws_instance.demoinstance.id
  port = 80
  depends_on = [aws_instance.demoinstance,]
}
resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id = aws_instance.demoinstance-2.id
  port = 80
  depends_on = [aws_instance.demoinstance-2,]
}
resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.external-alb.arn
  port = 80
  protocol = "HTTP"
 default_action {
  type = "forward" 
  target_group_arn = aws_lb_target_group.target-elb.arn
}
}
resource "aws_launch_configuration" "auto" {
  name_prefix     ="auto-scaling"
  image_id        = "ami-0beaa649c482330f7"
  instance_type   = "t2.micro"
  user_data       = file("data.sh")
  security_groups = ["${aws_security_group.demosg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "asg" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.auto.name
  vpc_zone_identifier  = [aws_subnet.public_subnet-1.id,aws_subnet.public_subnet-2.id]
}

resource "aws_autoscaling_attachment" "attachment-3" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn   = aws_lb_target_group.target-elb.arn
}

