aws_region                = "us-east-1"
environment               = "dev"
name                      = "hello-world-win"
vpc_name                  = "default"
az_count                  = 1
image_id                  = "ami-57beda41"
instance_type             = "t2.medium"
stack_env                 = "devenv"
stack_name                = "hello-world-win"
web_max_size              = "1"
web_min_size              = "1"
web_desired_capacity      = "1"
healthcheck_type          = "ELB"
access_key 				  = ""
secret_key 				  = ""
