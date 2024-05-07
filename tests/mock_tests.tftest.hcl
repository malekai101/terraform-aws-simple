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
    condition     = aws_s3_bucket.bucket.bucket == "test_project-csmith101-bucket"
    error_message = "incorrect name"
  }
}