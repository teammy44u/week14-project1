resource "aws_security_group" "alb-sg" {
  description = "Allow inbound from everywhere to 80 and 443 port ( http and https protocols)"
  vpc_id      = aws_vpc.utc-app.id
  tags = {
    Name = "alb-sg"
    env  = var.environment
    team = var.team
  }
  ingress {
    description = "open port 80 - http"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  ingress {
    description = "open port 443 - https"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    description = "from everywhere"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = -1
  }
}

resource "aws_security_group" "bastion-host-sg" {
  description = "Allow only ssh"
  vpc_id      = aws_vpc.utc-app.id
  tags = {
    Name = "bastion-host-sg"
    env  = var.environment
    team = var.team
  }
  ingress {
    description = "open port 22 for ssh from my ip address "
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.my-ip-address]
    protocol    = "tcp"
  }

  egress {
    description = "from everywhere"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = -1
  }
}

resource "aws_security_group" "app-server-sg" {
  description = "Allow inbound from alb sg to 80 ( http protocol) & from bastion-host-sg to 22 ( ssh protocol)"
  vpc_id      = aws_vpc.utc-app.id
  tags = {
    Name = "app-server-sg"
    env  = var.environment
    team = var.team
  }
  ingress {
    description     = "open port 80 to alb sg"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb-sg.id]
    protocol        = "tcp"
  }

  ingress {
    description     = "open port 22 to bastion host"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion-host-sg.id]
    protocol        = "tcp"
  }

  egress {
    description = "from everywhere"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = -1
  }
}

resource "aws_security_group" "database-sg" {
  #description = "Allow inbound from app-server sg to 3306 ( mysql protocol)"
  vpc_id = aws_vpc.utc-app.id
  tags = {
    Name = "database-sg"
    env  = var.environment
    team = var.team
  }
  ingress {
    description     = "open port 3306 from app-server"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.app-server-sg.id]
    protocol        = "tcp"
  }

  egress {
    description = "from everywhere"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = -1
  }
}