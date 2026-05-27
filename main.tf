provider "aws" {
  region = "us-east-1"

 
}

variable "instance_names" {
  type    = list(string)
  default = ["jenkins", "APPSERVER-1", "APPSERVER-2", "Monitoring server"]
}

# 1. Define a NEW Security Group that will be created in your Member Account
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group for Netflix app servers"
  vpc_id      = "vpc-0a1c70c25aa611d04" 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Deploy EC2 Instances referencing the NEW security group
resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-04aa00acb1165b32a"
  instance_type          = "t2.medium"
  key_name               = "DeOps-Admin"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  
  tags = {
    Name = var.instance_names[count.index]
  }
}


