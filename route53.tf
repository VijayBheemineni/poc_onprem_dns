resource "aws_route53_zone" "aws_private_hostedzone" {
  name = var.aws_private_hostedzone
  vpc {
    vpc_id = var.awsvpc_id
  }
}

resource "aws_route53_record" "dnstest" {
  zone_id = aws_route53_zone.aws_private_hostedzone.zone_id
  name    = var.aws_private_hostedzone_dummyresource_name
  type    = "A"
  ttl     = 300
  records = [var.aws_private_hostedzone_dummyresource_ipaddress]
}
