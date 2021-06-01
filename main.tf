provider "aws" {
    profile = "vaxowave"
    region = "us-east-1"
}

module "codecommit_repository" {
  source = "./Modules/codecommit_repository/"
  repository_name = "repository_main"
  tags = {
    Name = "Stefan Rheeders Main Repository"
    Department = "Intern"
  }
}

module "codebuild_project" {
  source = "./Modules/codebuild_project/"
  project_name = "project_main"
  code_commit_location = module.codecommit_repository.repository_name
  artifact_location = aws_s3_bucket.rheeders-bucket-pipeline.bucket

  tags = {
    Name = "Stefan Rheeders Main Project"
    Department = "Intern"
  }
}

module "codepipeline" {
  source = "./Modules/codepipeline/"
  codecommit_repository_name = module.codecommit_repository.repository_name
  artifact_location = aws_s3_bucket.rheeders-bucket-pipeline.bucket
  codecommit_repository_arn = module.codecommit_repository.repository_arn
  artifact_arn = aws_s3_bucket.rheeders-bucket-pipeline.arn
  tags = {
    Name = "Stefan Rheeders Main Pipeline"
    Department = "Intern"
  }
}

resource "aws_s3_bucket" "rheeders-bucket-pipeline" {
  bucket = "rheeders-bucket-pipeline"
  acl = "public-read-write"

  versioning {
    enabled = false
    mfa_delete = false
  }

  tags = {
      Name = "Stefan Rheeders Pipeline Bucket"
      Department = "Intern"
  }
}

resource "aws_s3_bucket" "rheeders-bucket-backend" {
  bucket = "rheeders-bucket-backend"
  acl = "private"

  versioning {
    enabled = false
    mfa_delete = false
  }

  tags = {
      Name = "Stefan Rheeders Bucket Backend"
      Department = "Intern"
  }
}

resource "aws_iam_role" "terraform_role" {
  name = "rheeders-role-terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "terraform_role2" {
  name = "rheeders-role-terraform2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "backend_policy2" {
  name = "rheeders-policy-backend2"
  role = aws_iam_role.terraform_role2.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.rheeders-bucket-backend.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.rheeders-bucket-backend.arn}/terraform.tfstate"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "backend_policy" {
  name = "rheeders-policy-backend"
  role = aws_iam_role.terraform_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.rheeders-bucket-backend.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.rheeders-bucket-backend.arn}/terraform.tfstate"
    }
  ]
}
EOF
}