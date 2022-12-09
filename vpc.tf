# update terraform
# aws is my provider

provider "aws" {
  region = "us-east-2"
  access_key = "AKIAX4NLJCBAZNBWCC2Y"
  secret_key = "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"
}
# creating vpc
resource "aws_vpc" "demovpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
}
# creating internet gateway
resource "aws_internet_gateway" "demoigw" {
  vpc_id = aws_vpc.demovpc.id
}
# creating subnets
resource "aws_subnet" "public_subnet-1" {
  vpc_id = aws_vpc.demovpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"
}
# creating subnets
resource "aws_subnet" "public_subnet-2" {
  vpc_id = aws_vpc.demovpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2b"
}
# creating route table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id
route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.demoigw.id
}
}
# associating with subnet
resource "aws_route_table_association" "rt1" {
  subnet_id = aws_subnet.public_subnet-1.id
  route_table_id = aws_route_table.route.id
}
# associatihng with subnet
resource "aws_route_table_association" "rt2" {
  subnet_id = aws_subnet.public_subnet-2.id
  route_table_id = aws_route_table.route.id
}

