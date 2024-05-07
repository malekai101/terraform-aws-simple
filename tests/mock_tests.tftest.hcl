mock_provider "aws" {
    override_data {
    target = data.aws_ami.linux_ami
    values = {
      architecture = "x86_64"
    }
  }
}

variables {
  project_name = "test_project"
  admin_ip = "76.205.132.95/32"
  key = "csmith-sandbox-east2"
  region = "us-east2"
}

run "sets_correct_name" {

  assert {
    condition     = aws_vpc.main_vpc.tags_all["Name"] == "Project test_project VPC"
    error_message = "incorrect vpc name"
  }

  assert {
    condition     = aws_instance.application.tags_all["Name"] == "App Server Test"
    error_message = "incorrect server name"
  }
}