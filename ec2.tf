# creating ec2 instance 
resource "aws_instance" "demoinstance" {
  ami = "ami-0beaa649c482330f7"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet-1.id
  key_name = "joke"  
  vpc_security_group_ids = ["${aws_security_group.demosg.id}"]
  associate_public_ip_address = true
  user_data = file("data.sh")
}
# creating ec2 instance
resource "aws_instance" "demoinstance-2" {
  ami = "ami-0beaa649c482330f7"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet-2.id
  key_name = "joke"
  vpc_security_group_ids = ["${aws_security_group.demosg.id}"]
  associate_public_ip_address = true
  user_data = file("data.sh")
}
