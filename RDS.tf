# resource "aws_db_instance" "utc-dev-database" {
#   allocated_storage    = 10
#   db_name              = "utc-dev-database"
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   username             = "utcuser"
#   password             = "utcdev12345"
#   #parameter_group_name = "default.mysql8.0"
#   skip_final_snapshot  = true
#   vpc_security_group_ids = [aws_security_group.database-sg.id]
# }