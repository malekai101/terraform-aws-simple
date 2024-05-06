/*
We are dynamically pulling the newest version of Amazon Linux.
Later in the code we will tell the VMs not to rebuild if this 
changes.
*/
data aws_ami "linux_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

/*
Since we are building web servers we will create a security group to
allow access to ports 80 and 443 to these servers.
*/
resource "aws_security_group" "allow_web" {
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Incoming Web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Incoming Secure Web"
    from_port   = 443
    to_port     = 443
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

resource "aws_security_group" "allow_boundary" {
  description = "Allow Boundary traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Incoming Boundary"
    from_port   = 9202
    to_port     = 9202
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

/*
Our VMs.  We are building a number of VMs equal to the 
server count variable.  We are also installing apache on
them.
*/
resource "aws_instance" "application" {
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.demo_subnet.id
  vpc_security_group_ids      = [
    aws_security_group.allow_web.id,
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_boundary.id
  ]
  key_name                    = var.key
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [
      ami,
    ]
    precondition {
      condition     = data.aws_ami.linux_ami.architecture == "x86_64"
      error_message = "The selected AMI must be for the x86_64 architecture."
    }

    # The EC2 instance must be allocated a public DNS hostname.
    postcondition {
      condition     = self.public_dns != ""
      error_message = "EC2 instance must be in a VPC that has public DNS hostnames enabled."
    }
  }

  tags = {
    Project = var.project_name
    Name    = "App Server Test"
  }

  user_data = local.scriptstr
}

// Our install script on start up
locals {
  scriptstr = <<-EOF
  #!/bin/bash
  sudo yum install -y httpd
  sudo systemctl enable httpd
  sudo systemctl start httpd
  EOF
  preserve = true
}