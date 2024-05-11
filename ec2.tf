resource "aws_instance" "app-server" {
  count                  = 2
  ami                    = "ami-0a1179631ec8933d7"
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.app-server-sg.id]
  subnet_id              = aws_subnet.private_subnet[count.index].id
  availability_zone      = count.index == 0 ? "us-east-1a" : "us-east-1b"
  tags = {
    Name = "app-server-${count.index}"
    env  = var.environment
    team = var.team
  }
  user_data            = file("user_data.sh")
  iam_instance_profile = aws_iam_instance_profile.allow-s3-to-ec2.name ###Attaching the role to the ec2 instances
}

resource "aws_instance" "bastion-host" {
  count                  = 1
  ami                    = "ami-0a1179631ec8933d7"
  instance_type          = "t2.micro"
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.bastion-host-sg.id]
  subnet_id              = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "bastion-host"
    env  = var.environment
    team = var.team
  }
}

resource "null_resource" "name" {
  count = 1
  connection {
    type        = "ssh"
    port        = 22
    user        = "ec2-user"
    host        = aws_instance.bastion-host[0].public_ip
    private_key = file(local_file.utc-key.filename)
  }

  provisioner "file" {
    source      = "utc-key.pem"
    destination = "/home/ec2-user/utc-key.pem"
  }

  provisioner "remote-exec" {
    inline = ["chmod 400 utc-key.pem"]
  }

  depends_on = [aws_instance.bastion-host, local_file.utc-key]
}