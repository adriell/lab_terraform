provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "app_hacklab" {
  ami = "ami-2d39803a"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.app_hacklab.id}"]
  user_data = <<-EOF
            #!/bin/bash
            echo "Olá, mundo!" > index.html
            nohup busybox httpd -f -p "${var.server_port}" &
            EOF
  tags{
      Name = "Owner.app_hacklab"
  }
}
resource "aws_security_group" "app_hacklab" {
    name = "sg_hacklab"
    description = "Security Groups Hacklab"
    #Rules Inbound
    ingress {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "SG HackLab"
    }  
}


