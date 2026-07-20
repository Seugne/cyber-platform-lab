# -----------------------------------------------------------------------------
# CloudGuard RDS PostgreSQL
#
# Security posture:
# - private subnets only
# - no public accessibility
# - inbound PostgreSQL only from sg-app
# - KMS encryption
# - Secrets Manager-managed master password
# - automated backups
# - Enhanced Monitoring
# - deletion protection enabled by default
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# DB subnet group
#
# RDS requires subnets in at least two Availability Zones.
# -----------------------------------------------------------------------------

resource "aws_db_subnet_group" "cloudguard" {
  name        = "${local.project_name}-db-subnet-group"
  description = "Private subnet group used by the CloudGuard PostgreSQL database"
  subnet_ids  = aws_subnet.private[*].id

  tags = {
    Name = "${local.project_name}-db-subnet-group"
    Role = "database"
  }
}

# -----------------------------------------------------------------------------
# PostgreSQL parameter group
# -----------------------------------------------------------------------------

resource "aws_db_parameter_group" "postgresql" {
  name        = "${local.project_name}-postgresql-parameter-group"
  family      = "postgres17"
  description = "CloudGuard PostgreSQL security and logging parameters"

  parameter {
    name         = "log_connections"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_disconnections"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_lock_waits"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_min_duration_statement"
    value        = "1000"
    apply_method = "immediate"
  }

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "immediate"
  }

  tags = {
    Name = "${local.project_name}-postgresql-parameter-group"
    Role = "database"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------------------------------------
# PostgreSQL database instance
# -----------------------------------------------------------------------------

resource "aws_db_instance" "postgresql" {
  identifier = "${local.project_name}-postgresql"

  engine         = "postgres"
  engine_version = "17"
  instance_class = var.database_instance_class

  db_name  = var.database_name
  username = var.database_master_username
  port     = local.database_port

  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.cloudguard.key_id

  allocated_storage     = var.database_allocated_storage
  max_allocated_storage = var.database_max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = aws_kms_key.cloudguard.arn

  db_subnet_group_name = aws_db_subnet_group.cloudguard.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false
  multi_az            = var.database_multi_az

  parameter_group_name = aws_db_parameter_group.postgresql.name

  backup_retention_period = var.database_backup_retention_days
  backup_window           = "02:00-03:00"
  maintenance_window      = "sun:03:30-sun:04:30"

  auto_minor_version_upgrade = true

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  performance_insights_enabled          = true
  performance_insights_kms_key_id       = aws_kms_key.cloudguard.arn
  performance_insights_retention_period = 7

  deletion_protection = var.database_deletion_protection

  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.project_name}-postgresql-final-snapshot"

  copy_tags_to_snapshot = true

  apply_immediately = false

  tags = {
    Name = "${local.project_name}-rds-postgresql"
    Role = "database"
  }

  depends_on = [
    aws_iam_role_policy_attachment.rds_enhanced_monitoring
  ]
}
