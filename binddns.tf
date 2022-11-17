data "aws_vpc" "onprem_vpc" {
  id = var.onprem_vpc_id
}

data "aws_vpc" "awsvpc" {
  id = var.awsvpc_id
}

resource "aws_security_group" "allow_dns_query" {
  name        = "Bind DNS Server SG"
  description = "Allow ssh inbound traffic"
  vpc_id      = var.onprem_vpc_id

  ingress {
    description = "SSH from Home IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.onprem_bindserver_allow_ssh]
  }

  ingress {
    description = "DNS from AWS VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.awsvpc.cidr_block]
  }

  ingress {
    description = "DNS from AWS VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.awsvpc.cidr_block]
  }

  ingress {
    description = "DNS from AWS VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.onprem_vpc.cidr_block]
  }

  ingress {
    description = "DNS from AWS VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [data.aws_vpc.onprem_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "bind_dns" {
  ami                         = var.ubuntu_bindserver_ami_id
  associate_public_ip_address = true
  instance_type               = var.ubuntu_bindserver_instance_type
  key_name                    = var.ssh_keyname
  subnet_id                   = var.bindserver_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_dns_query.id]
  user_data = templatefile(
    "${path.module}/templates/userdata.sh.tftpl",
    {
      ONPREM_CIDR                           = data.aws_vpc.onprem_vpc.cidr_block,
      AWSVPC_CIDR                           = data.aws_vpc.awsvpc.cidr_block,
      ONPREM_DNS_DOMAIN                     = var.onprem_test_domain_name,
      AWS_DNS_PRIVATE_DOMAIN                = var.aws_private_hostedzone,
      AWS_ROUTE53_INBOUND_ENDPOINT_IP1      = var.aws_route53_inbound_endpoint_ip1,
      AWS_ROUTE53_INBOUND_ENDPOINT_IP2      = var.aws_route53_inbound_endpoint_ip2,
      ONPREM_DOMAIN_DUMMYRESOURCE_NAME      = var.onprem_domain_dummyresource_name,
      ONPREM_DOMAIN_DUMMYRESOURCE_IPADDRESS = var.onprem_domain_dummyresource_ipaddress
    }
  )
  tags = merge(
    {
      Name = "BindDNSServer"
    }
  )
}
