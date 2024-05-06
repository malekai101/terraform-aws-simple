
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