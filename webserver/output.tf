output "public_ip" {
  value = "${aws_instance.app_hacklab.public_ip}"
}
