output "SSH-FOR-BASTION-HOST" {
  value = "ssh -i utc-key.pem ec2-user@${aws_instance.bastion-host[0].public_ip}"
}

output "APP_SERVER0_PRIVATE_IP" {
  value = aws_instance.app-server[0].private_ip
}

output "APP_SERVER1_PRIVATE_IP" {
  value = aws_instance.app-server[1].private_ip
}