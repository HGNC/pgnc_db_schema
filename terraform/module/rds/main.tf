module "rds" {
  source                      = "terraform-aws-modules/rds/aws"
  version                     = "6.9.0"
  identifier                  = "pgncdb"
  engine                      = "postgres"
  engine_version              = "16.3"
  engine_lifecycle_support    = "open-source-rds-extended-support-disabled"
  family                      = "postgres16" # DB parameter group
  option_group_name           = "default-postgres-16"
  major_engine_version        = "16" # DB option group
  instance_class              = "db.t4g.micro"
  storage_type                = "gp3"
  allocated_storage           = 20
  max_allocated_storage       = 20
  db_name                     = "postgres"
  username                    = var.rds_admin_username
  password                    = var.rds_admin_password
  manage_master_user_password = false
  port                        = 5432
  skip_final_snapshot         = false
  backup_window               = "00:07-00:37"
  backup_retention_period     = 16
  maintenance_window          = "Fri:00:45-Fri:01:15"
  vpc_security_group_ids      = var.vpc_security_group_ids
  db_subnet_group_name        = var.db_subnet_group_name
  multi_az                    = false
  availability_zone           = var.availability_zones[0]
  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    },
    {
      name  = "timezone"
      value = "UTC"
    },
    {
      name         = "rds.force_ssl"
      value        = 0
      apply_method = "pending-reboot"
    }
  ]
}
