provider "aws" {
  access_key = ""
  secret_key = ""
  region = "ap-south-1"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "ClusteroZonaloMinimal"
  role_arn = "arn:aws:iam::501503749031:role/ECR"
vpc_config {
    subnet_ids = ["subnet-0ddd511fd0616c8d7","subnet-0077c377ff938bcc7"]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
}
resource "aws_iam_role" "eks_cluster" {
  name = "eks_cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_launch_configuration" "zonal" {
  name_prefix   = "zonal-eks-cluster"
  image_id      = "ami-0f8ca728008ff5af4"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "zonal-auto" {
  name                 = "zonal-cluster"
  launch_configuration = aws_launch_configuration.zonal.name
  vpc_zone_identifier  = ["subnet-0ddd511fd0616c8d7","subnet-0077c377ff938bcc7"]
  desired_capacity     = 1
  min_size             = 1
  max_size             = 2

}
