
// The VPC in which our project will live.
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Project = var.project_name
    Name    = "Project ${var.project_name} VPC"
  }
}

// Only using one subnet with a /24.  
resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.0.0/24"

  tags = {
    Project = var.project_name
    Name    = "${var.project_name} subnet 0"
  }
}

resource "aws_internet_gateway" "main_gate" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Internet-gateway"
  }
}

/*
Using a custom route table to route traffic from our subnet through
the Internet gateway.
*/
resource "aws_route_table" "out_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gate.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.out_route.id
}

/*
A security group to allow SSH traffic from the Internet to 
our VMs but only from the admin IP CIDR block being passed
to the Terraform code.  

This solution is for demo only and is not the best solution.
In production we would use a Bastion host, a VPN, a transit gateway,
or HashiCorp Boundary.
*/
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // The admin block to allow access to SSH.
    cidr_blocks = [var.admin_ip, "10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

check "health_check" {
  data "http" "terraform_io" {
    url = "https://www.terraform.io"
  }

  assert {
    condition = data.http.terraform_io.status_code == 200
    error_message = "${data.http.terraform_io.url} returned an unhealthy status code"
  }
}
