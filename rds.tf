resource "aws_db_instance" "jh-db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  identifier           = "jh-db"
  db_name              = "jhDB"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.jh-private-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.jh-rds-subnet-group.name
}
