
variable "aws_region"                   {}
variable "az_count"                     {}
variable "env_tag"                      {}
variable "healthcheck_type"             {}
variable "image_id"                     {}
variable "instance_type"                {}
variable "stack_env"                    {}
variable "stack_name"                   {}
variable "vpc_name"                     {}
variable "web_desired_capacity"         {}
variable "web_max_size"                 {}
variable "web_min_size"                 {}
variable "access_key"                 {}
variable "secret_key"                 {}

provider "aws" {
  region  = "${var.aws_region}" 
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}" 
}

data "aws_security_group" "hello-world" {
  tags {
    Name = "ec2-sg"
  }
}

data "aws_security_group" "hello-world-lb" {
  tags {
    Name = "elb-sg"
  }
}

data "aws_vpc" "onboarding" {
  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_elb" "webserver" {
  name                      = "${var.stack_name}-web-${var.stack_env}"
  security_groups           = ["${data.aws_security_group.hello-world-lb.id}"]
  subnets                   = ["subnet-9636b0aa"] //change subnet here
  internal                  = "false"
  cross_zone_load_balancing = "false"
  idle_timeout              = 60
  listener                  = {
    instance_port     = 80
    instance_protocol = "TCP"
    lb_port           = 80
    lb_protocol       = "TCP"
  }
  health_check              = {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
  }
  tags {
    Name                   = "${var.stack_name}-web-${var.stack_env}"    
    Environment            = "${var.stack_env}"
  }
}

resource "aws_launch_configuration" "webserver" {
  name_prefix     = "${var.stack_name}-web-"
  image_id        = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${data.aws_security_group.hello-world.id}"]  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver" {
  name                      = "${aws_launch_configuration.webserver.name}"
  max_size                  = "${var.web_max_size}"
  min_size                  = "${var.web_min_size}"
  desired_capacity          = "${var.web_desired_capacity}"
  wait_for_elb_capacity     = "1"
  wait_for_capacity_timeout = "25m"
  launch_configuration      = "${aws_launch_configuration.webserver.id}"
  health_check_grace_period = 1500
  health_check_type         = "${var.healthcheck_type}"
  load_balancers            = ["${aws_elb.webserver.id}"]
  vpc_zone_identifier       = ["subnet-9636b0aa"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.stack_name}-web"
    propagate_at_launch = true
  } 
  tag {
    key                 = "Environment"
    value               = "${var.env_tag}"
    propagate_at_launch = true
  }
}

output "webserver_elb_dns_name"   { value = "${aws_elb.webserver.dns_name}" }
output "webserver_elb_zone_id"    { value = "${aws_elb.webserver.zone_id}" }
