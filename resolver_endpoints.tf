resource "aws_security_group" "route53_resolver_inbound" {
  name        = "Route53 Resolver Inbound Endpoint"
  description = "Allow DNS queries from OnPrem"
  vpc_id      = var.awsvpc_id

  ingress {
    description = "DNS from OnPrem VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.onprem_vpc.cidr_block]
  }

  ingress {
    description = "DNS from OnPrem VPC"
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


resource "aws_route53_resolver_endpoint" "onprem_inbound" {
  name      = "OnPremInbound"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.route53_resolver_inbound.id,
  ]

  ip_address {
    subnet_id = var.aws_resolver_endpoints_subnet_id1
    ip        = var.aws_route53_inbound_endpoint_ip1
  }

  ip_address {
    subnet_id = var.aws_resolver_endpoints_subnet_id2
    ip        = var.aws_route53_inbound_endpoint_ip2
  }

}


resource "aws_security_group" "route53_resolver_outbound" {
  name        = "Route53 Resolver Outbound Endpoint"
  description = "Allow DNS queries from AWS to OnPrem"
  vpc_id      = var.awsvpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_route53_resolver_endpoint" "onprem_outbound" {
  name      = "OnPremOutbound"
  direction = "OUTBOUND"

  security_group_ids = [
    aws_security_group.route53_resolver_outbound.id,
  ]

  ip_address {
    subnet_id = var.aws_resolver_endpoints_subnet_id1
  }

  ip_address {
    subnet_id = var.aws_resolver_endpoints_subnet_id2
  }

}

resource "aws_route53_resolver_rule" "allcloudonprem" {
  domain_name          = var.onprem_test_domain_name
  name                 = "allcloudonprem"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.onprem_outbound.id

  target_ip {
    ip = aws_instance.bind_dns.private_ip
  }
  depends_on = [
    aws_instance.bind_dns
  ]
}

resource "aws_route53_resolver_rule_association" "onprem" {
  resolver_rule_id = aws_route53_resolver_rule.allcloudonprem.id
  vpc_id           = var.awsvpc_id
}
