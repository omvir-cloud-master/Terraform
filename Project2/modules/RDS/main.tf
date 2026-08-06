######################################################
# DB Subnet Group
######################################################
resource "aws_db_subnet_group" "rds_subnet_group" {

  name       = "rds-subnet-group-${var.environment}"
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "rds-subnet-group-${var.environment}"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "mysql-${var.environment}"
  allocated_storage       = 20
  storage_type            = "gp3"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "mydb"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.rds_security_group_id]
  publicly_accessible     = false
  multi_az                = true
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"
  monitoring_interval     = 0
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "mysql-${var.environment}"
  }
}

###############################################
# Read Replica
##############################################

resource "aws_db_instance" "mysql_replica" {
  identifier                 = "mysql-replica-${var.environment}"
  replicate_source_db        = aws_db_instance.mysql.identifier
  instance_class             = "db.t3.micro"
  publicly_accessible        = false
  auto_minor_version_upgrade = true
  skip_final_snapshot        = true

  tags = {
    Name = "mysql-replica-${var.environment}"
  }
}