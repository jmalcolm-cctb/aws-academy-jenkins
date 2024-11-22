resource "tls_private_key" "jkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "secret_key" {
  key_name   = "jenkinskey"
  public_key = tls_private_key.jkey.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.jkey.private_key_pem
  sensitive = true
}
