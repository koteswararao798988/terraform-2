# creating auto scaling 
resource "aws_launch_configuration" "demolaunch" {
  name_prefix = "learn-terraform-aws-asg"
  image_id = "ami-0beaa649c482330f7"
  instance_type = "t2.micro"
  user_data = file("data.sh")
  security_groups = [aws_security_group.demosg.id]

lifecycle {
  create_before_destroy = true
}
}
resource "aws_autoscaling_group" "demoauto" {
  min_size = 1
  max_size = 3
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.demolaunch.name
  vpc_zone_identifier = [aws_subnet.public_subnet-1.id,aws_subnet.public_subnet-2.id]
}
resource "aws_autoscaling_attachment" "attachment" {
  autoscaling_group_name = aws_autoscaling_group.demoauto.id
  lb_target_group_arn = aws_lb_target_group.target-elb.arn
}
