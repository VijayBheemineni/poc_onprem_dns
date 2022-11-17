resource "aws_vpc_dhcp_options" "onprem" {
  domain_name          = var.onprem_test_domain_name
  domain_name_servers  = [aws_instance.bind_dns.private_ip]
  tags = {
    Name = var.onprem_test_domain_name
  }
}

# Forced to create this resource because DHCP options should be attached to VPC only after Bind Server EC2 instance comes up.
resource "time_sleep" "vpc_dhcp_association_waittime" {
  depends_on = [aws_instance.bind_dns]
  create_duration = "60s"
}


resource "aws_vpc_dhcp_options_association" "onprem_dns_resolver" {
  vpc_id          = var.onprem_vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.onprem.id
  depends_on = [time_sleep.vpc_dhcp_association_waittime]
}

# Forced to use this option because EC2 instance must be restarted to pickup updated DHCP configuration which contains Bind DNS Server information.
resource "time_sleep" "restart_waittime" {
  depends_on = [aws_vpc_dhcp_options_association.onprem_dns_resolver]
  create_duration = "60s"
}

resource "null_resource" "restart_bindserver" {
  provisioner "local-exec" {
    command = "aws ec2 reboot-instances --instance-ids ${aws_instance.bind_dns.id}"
  }
  depends_on = [time_sleep.restart_waittime]
}