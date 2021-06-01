provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "pipeline3_test_instance" {
    ami = "ami-0742b4e673072066f"
    instance_type = "t2.micro"

    tags = {
        Name = "Stefan Rheeders Pipeline Test Instance"
        Department = "Intern"
    } 
}

terraform {
  backend "s3" {
      bucket = "rheeders-bucket-backend"
      key = "pipeline"
      region = "us-east-1"
  }
}