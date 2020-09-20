provider "aws" {
  region = "us-east-1"
}


variable "ingress_rules" {
  type    = list(number)
  default = [25, 80, 443, 8080, 8443]

}
variable "egress_rules" {
  type    = list(number)
  default = [443, 8443]
}
resource "aws_instance" "myec2" {
  ami                = "ami-0c94855ba95c71c99"
  instance_type      = "t2.micro"
  tags = {
    Name = "web Server"
  }
}

resource "aws_security_group" "web_traffic" {
  name = "secure server"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

 dynamic "egress" {
  iterator = port
  for_each = var.egress_rules
  content {
    from_port   = port.value
    to_port     = port.value
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
}