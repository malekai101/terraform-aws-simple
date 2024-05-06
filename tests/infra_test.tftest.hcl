
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

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
