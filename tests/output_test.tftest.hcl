
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