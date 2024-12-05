resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "lab13.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = var.main_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

resource "aws_route53_zone" "main" {
  name = "lab13.internal"
  vpc {
    vpc_id = var.main_vpc.id
  }
}

resource "aws_route53_record" "instance1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.instance_1_name}.lab13.internal"
  type    = "A"
  ttl     = "300"
  records = [var.instance_1_private_ip]
}

resource "aws_route53_record" "instance2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.instance_2_name}.lab13.internal"
  type    = "A"
  ttl     = "300"
  records = [var.instance_2_private_ip]

}