provider "aws" {
  access_key = "AKIAXJQ7T5OT7P4LD56A"
  secret_key = "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"
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