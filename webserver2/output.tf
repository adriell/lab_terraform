output "elb_dns_name" {
  value = "${aws_elb.elb_hacklab.dns_name}"
}