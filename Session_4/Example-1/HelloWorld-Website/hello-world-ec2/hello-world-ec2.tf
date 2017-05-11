
variable "aws_region"                   {}
variable "az_count"                     {}
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

module "compute" {
  source                      = "compute"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}" 
  aws_region                  = "${var.aws_region}"
  az_count                    = "${var.az_count}"   
  env_tag                     = "${var.stack_env}"
  healthcheck_type            = "${var.healthcheck_type}"  
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  web_desired_capacity          = "${var.web_desired_capacity}"
  web_max_size                  = "${var.web_max_size}"
  web_min_size                  = "${var.web_min_size}"  
  stack_env                   = "${var.stack_env}"
  stack_name                  = "${var.stack_name}"
  vpc_name                    = "${var.vpc_name}"  
}


output "webserver_elb_dns_name"   { value = "${module.compute.webserver_elb_dns_name}" }
