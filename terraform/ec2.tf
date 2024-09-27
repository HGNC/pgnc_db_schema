resource "aws_instance" "pgnc-bastion" {
  ami                         = "ami-01ec84b284795cbc7"
  associate_public_ip_address = "true"
  availability_zone           = var.availability_zones[0]
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id, aws_security_group.ec2_rds_1.id, aws_security_group.allow_all_outbound.id]
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "false"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  ipv6_address_count                   = "0"
  key_name                             = "pgnc"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "2"
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  provisioner "file" {
    source      = "../pgnc-public.sql"
    destination = "/tmp/pgnc-public.sql"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt-get install -y postgresql-client",
      " PGPASSWORD=${local.rds_admin_creds.password} psql -h ${module.pgnc_rds.db_instance_address} -U ${local.rds_admin_creds.username} -d postgres -f /tmp/pgnc-public.sql",
      "rm /tmp/terraform_*.ssh",
      "rm /tmp/pgnc-public.sql"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    timeout     = "4m"
  }

  tags = {
    Name = "pgnc-bastion"
  }
}
