provider "aws" {
  access_key = "${var.aws_access_key}"
   secret_key = "${var.aws_secret_key}"
   region = "${var.aws_region}" 	
}
// cretae SG-1
resource "aws_security_group" "test-SG1" {
  vpc_id 		      = "${var.vpc_id}"
  name                = "my-test-SG1"
  description         = "my-test-SG1"
  
}

resource "aws_security_group_rule" "enable_http_80_from_anywhere" {
    type                      = "ingress"
    from_port                 = 80
    to_port                   = 80
    protocol                  = "tcp"
    security_group_id         = "${aws_security_group.test-SG1.id}"
    cidr_blocks               = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "enable_rdp" {
    type                      = "ingress"
    from_port                 = 3389
    to_port                   = 3389
    protocol                  = "tcp"
    security_group_id         = "${aws_security_group.test-SG1.id}"
    cidr_blocks               = ["10.0.0.0/8"]
}


output "test_sg1_id"     { value = "${aws_security_group.test-SG1.id}" }

