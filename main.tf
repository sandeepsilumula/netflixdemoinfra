provider "aws" {
  region = "us-east-1"

  # You MUST include this to switch into your Member Account
  assume_role {
    # Replace this ARN with the one from your Member Account
    role_arn     = "arn:aws:iam::123456789012:role/TerraformDeploymentRole"
    session_name = "Terraform-Member-Deployment"
  }
}

# 1. Define a NEW Security Group resource
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group for Netflix app servers"
  # IMPORTANT: Ensure this VPC ID actually exists in the MEMBER account
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

# 2. Deploy EC2 Instances referencing the new dynamic security group
resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-04aa00acb1165b32a"
  instance_type          = "t2.medium"
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