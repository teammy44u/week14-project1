resource "tls_private_key" "utc-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "utc-key" {
  key_name   = var.key_pair
  public_key = tls_private_key.utc-key.public_key_openssh
}

resource "local_file" "utc-key" {
  filename = var.private_key_filename
  content  = tls_private_key.utc-key.private_key_pem
}