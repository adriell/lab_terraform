provider "aws" {
  region = "us-east-1"
}
data "aws_availability_zones" "available" {}

resource "aws_autoscaling_group" "asg_hacklab" {
  launch_configuration = "${aws_launch_configuration.lc_hacklab.id}"
  availability_zones = ["${data.aws_availability_zones.available.names}"]
  min_size = 2
  max_size = 5
  load_balancers = ["${aws_elb.elb_hacklab.name}"]
  health_check_type = "ELB"
  tag {
      key = "Name"
      value = "terraform_asg.hacklab"
      propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "lc_hacklab"{
    image_id = "ami-2d39803a"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.app_hacklab.id}"]
    user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p "${var.server_port}" &
            EOF
    lifecycle {
        create_before_destroy = true
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
    lifecycle{
        create_before_destroy = true
    } 
}

resource "aws_elb" "elb_hacklab"{
    name = "elbhacklab"
    security_groups = ["${aws_security_group.elb_hacklab.id}"]
    availability_zones = ["${data.aws_availability_zones.available.names}"]
    health_check {
        healthy_threshold  = 2 
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }

}

resource "aws_security_group" "elb_hacklab" {
  name = "terraform SG elb"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




