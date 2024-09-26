resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "allow_all_outbound" {
  name        = "allow_all_outbound"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_all_outbound"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.allow_all_outbound.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_security_group" "rds_ec2_1" {
  name        = "rds_ec2_1"
  description = "Allow TCP traffic from RDS to bastion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "RDS to Bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_rds_ec2_1" {
  security_group_id            = aws_security_group.rds_ec2_1.id
  referenced_security_group_id = aws_security_group.ec2_rds_1.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}

resource "aws_security_group" "ec2_rds_1" {
  name        = "ec2_rds_1"
  description = "Allow TCP traffic from bastion to RDS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "Bastion to RDS"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_tcp_ec2_rds_1" {
  security_group_id            = aws_security_group.ec2_rds_1.id
  referenced_security_group_id = aws_security_group.rds_ec2_1.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}
