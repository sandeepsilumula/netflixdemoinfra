provider "aws" {
  region = "us-east-1"

 
}

variable "instance_names" {
  type    = list(string)
  default = ["jenkins", "APPSERVER-1", "APPSERVER-2", "Monitoring server"]
}

resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-04aa00acb1165b32a"
  instance_type          = "t2.medium"
  key_name               = "argocd"
  vpc_security_group_ids = ["sg-06785bc60f40dceda"]
  
  tags = {
    Name = var.instance_names[count.index]
  }
}
