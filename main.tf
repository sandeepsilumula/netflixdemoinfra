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
  instance_type          = "c7g.large"
  key_name               = "DevOps-Admin"
  vpc_security_group_ids = ["sg-0f9849bda64b07bba"]
  
  tags = {
    Name = var.instance_names[count.index]
  }
}