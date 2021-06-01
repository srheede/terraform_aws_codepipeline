resource "aws_codepipeline" "pipeline_main" {
    name = "pipeline_main"
    role_arn = aws_iam_role.pipeline_role.arn

    artifact_store {
      location = var.artifact_location
      type = "S3"
    }

    stage {
      name = "Source"

      action {
          name = "Source"
          category = "Source"
          owner = "AWS"
          provider = "CodeCommit"
          version = "1"
          output_artifacts = [ "source_output" ]

          configuration = {
              RepositoryName = var.codecommit_repository_name
              BranchName = "master"
          }
      }
    }

    stage {
      name = "Build"

      action {
          name = "Build"
          category = "Build"
          owner = "AWS"
          provider = "CodeBuild"
          input_artifacts = [ "source_output" ]
          output_artifacts = [ "build_output" ]
          version = "1"

          configuration = {
            ProjectName = var.codebuild_project_name
          }

      }
    }

    tags = var.tags
}

resource "aws_iam_role" "pipeline_role" {
  name = "rheeders-role-pipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "pipeline_policy" {
  name = "rheeders-policy-pipeline"
  role = aws_iam_role.pipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
            "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${var.artifact_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
                "codecommit:BatchGet*",
                "codecommit:BatchDescribe*",
                "codecommit:Describe*",
                "codecommit:EvaluatePullRequestApprovalRules",
                "codecommit:Get*",
                "codecommit:List*",
                "codecommit:GitPull",
                "codecommit:UploadArchive"
      ],
      "Resource": "${var.codecommit_repository_arn}"
    }
  ]
}
EOF
}