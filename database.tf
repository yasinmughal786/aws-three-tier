
# RDS subnet group across two Availability Zones
resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-db-subnets"

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# Private, encrypted MySQL database
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = "appadmin"

  # AWS manages the master password in Secrets Manager
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false

  backup_retention_period    = 1
  auto_minor_version_upgrade = true

  # Suitable only for a temporary learning project
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-mysql"
  }
}
