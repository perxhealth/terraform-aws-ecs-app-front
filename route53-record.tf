data "aws_route53_zone" "selected" {
  count = length(var.hosted_zones)
  name  = var.hosted_zones[count.index]
}

resource "aws_route53_record" "hostname" {
  count = var.hostname_create ? length(var.hostnames) : 0

  zone_id = data.aws_route53_zone.selected[count.index].zone_id
  name    = var.hostnames[count.index]
  type    = "CNAME"
  ttl     = "300"
  records = tolist([element(aws_cloudfront_distribution.default.*.domain_name, 0)])
}

