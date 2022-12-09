module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "deployer-one"
  create_private_key = true
}
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

