# ------------------------------
# RDS Parameter Group
# ------------------------------
resource "aws_db_parameter_group" "mysql_standalone_parameter_group" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# ------------------------------
# RDS Option Group
# ------------------------------
resource "aws_db_option_group" "mysql_standalone_option_group" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# ------------------------------
# RDS Subnet Group
# ------------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnet_group" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnet-group"
    Project = var.project
    Env     = var.environment
  }
}

# ------------------------------
# RDS Instance
# ------------------------------
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  engine         = "mysql"
  engine_version = "8.0.34"

  identifier = "${var.project}-${var.environment}-mysql-standalone"

  # user
  username = "admin"
  password = random_string.db_password.result

  # instance
  instance_class = "db.t2.micro"

  # storage
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  # network
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  name                 = "tastylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parameter_group.name
  option_group_name    = aws_db_option_group.mysql_standalone_option_group.name

  # backup
  # メンテナンスを行う場合、事前にバックアップを取得したほうがよい
  # したがって、メンテナンスウィンドウの前にバックアップウィンドウを設定する
  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  # 誤操作防止
  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}
