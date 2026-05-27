provider "aws" {
  region = "us-east-1"

  
}

# 1. Define a NEW Security Group resource
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group for Netflix app servers"
  vpc_id      = "vpc-0a1c70c25aa611d04" 

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins / Tomcat
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Deploy EC2 Instances referencing the new dynamic security group
resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-04aa00acb1165b32a"
  instance_type          = "c7i-flex.large"
  key_name               = "DeOps-Admin"
  
  # Reference the security group created by Terraform above
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  tags = {
    Name = var.instance_names[count.index]
  }
}

variable "instance_names" {
  type    = list(string)
  default = ["jenkins", "APPSERVER-1", "APPSERVER-2", "Monitoring server"]
}