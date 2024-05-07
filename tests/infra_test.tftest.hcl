
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

provider "aws" {
    region = "us-east-2"
}

variables {
  project_name = "test_project"
  admin_ip = "76.205.132.95/32"
  key = "csmith-sandbox-east2"
  region = "us-east2"
}

run "vpc_validation" {
  assert {
    condition     = aws_vpc.main_vpc.cidr_block == "10.0.0.0/16"
    error_message = "incorrect CIDR block for VPC"
  }

  assert {
    condition     = aws_vpc.main_vpc.enable_dns_hostnames == true
    error_message = "DNS hostnames should be enabled for VPC"
  }
}

run "subnet_validation" {
  assert {
    condition     = aws_subnet.demo_subnet.cidr_block == "10.0.0.0/24"
    error_message = "incorrect CIDR block for subnet"
  }
}

run "internet_gateway_validation" {
  assert {
    condition     = aws_internet_gateway.main_gate.vpc_id == aws_vpc.main_vpc.id
    error_message = "incorrect VPC ID for internet gateway"
  }
}

run "route_table_validation" {
  assert {
    condition     = aws_route_table.out_route.vpc_id == aws_vpc.main_vpc.id
    error_message = "incorrect VPC ID for route table"
  }
}

run "route_table_association_validation" {
  assert {
    condition     = aws_route_table_association.rta.subnet_id == aws_subnet.demo_subnet.id
    error_message = "incorrect subnet ID for route table association"
  }

  assert {
    condition     = aws_route_table_association.rta.route_table_id == aws_route_table.out_route.id
    error_message = "incorrect route table ID for route table association"
  }
}

run "security_group_validation" {
  assert {
    condition     = aws_security_group.allow_ssh.vpc_id == aws_vpc.main_vpc.id
    error_message = "incorrect VPC ID for security group"
  }
}

# Outputs

run "output_validation" {
  assert {
    condition     = output.vpc_id == aws_vpc.main_vpc.id
    error_message = "incorrect VPC ID output"
  }

  assert {
    condition     = output.vpc_name == aws_vpc.main_vpc.tags["Name"]
    error_message = "incorrect VPC name output"
  }

  assert {
    condition     = output.subnet_id == aws_subnet.demo_subnet.id
    error_message = "incorrect subnet ID output"
  }

  assert {
    condition     = output.ssh_rule_id == aws_security_group.allow_ssh.id
    error_message = "incorrect SSH rule ID output"
  }

  assert {
    condition     = output.instance_ids == aws_instance.application.id
    error_message = "incorrect instance IDs output"
  }

  assert {
    condition     = output.server_ip == aws_instance.application.public_ip
    error_message = "incorrect server IP output"
  }

  assert {
    condition     = output.server_dns == aws_instance.application.public_dns
    error_message = "incorrect server DNS output"
  }
}

# Vms

run "vm_validation" {
  assert {
    condition     = aws_instance.application.ami == data.aws_ami.linux_ami.id
    error_message = "incorrect AMI for VM"
  }

  assert {
    condition     = aws_instance.application.instance_type == "t2.micro"
    error_message = "incorrect instance type for VM"
  }

  assert {
    condition     = aws_instance.application.subnet_id == aws_subnet.demo_subnet.id
    error_message = "incorrect subnet ID for VM"
  }

  assert {
    condition     = aws_instance.application.key_name == var.key
    error_message = "incorrect key name for VM"
  }

  assert {
    condition     = aws_instance.application.associate_public_ip_address == true
    error_message = "public IP address should be associated with VM"
  }
}