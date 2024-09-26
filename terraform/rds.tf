data "aws_secretsmanager_secret_version" "rds_admin_creds" {
  secret_id = "rds_admin_creds"
}

locals {
  rds_admin_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_admin_creds.secret_string)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "pgncdb_subnet_group"
  subnet_ids = aws_subnet.private_db_subnets[*].id
  tags = {
    Name = "My DB subnet group"
  }
}

module "pgnc_rds" {
  source                 = "./module/rds"
  vpc_security_group_ids = [aws_security_group.rds_ec2_1.id, aws_default_security_group.default.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  rds_admin_username     = local.rds_admin_creds.username
  rds_admin_password     = local.rds_admin_creds.password
}
