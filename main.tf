provider "aws" {
  region = "us-east-1"
}

variable "instance_names" {
  type    = list(string)
  default = ["jenkins", "APPSERVER-1", "APPSERVER-2", "Monitoring server"]
}

resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-091138d0f0d41ff90"
  instance_type          = "c7i-flex.large"
  key_name               = "DeOps-Admin"
  vpc_security_group_ids = ["subnet-036834075c87e087f"]
  
  tags = {
    Name = var.instance_names[count.index]
  }
}
