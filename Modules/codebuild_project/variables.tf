variable project_name {
    type = string
    default = "project_main"
}

variable code_commit_location {
    type = string
}

variable artifact_location {
    type = string
}

variable tags {
    type = any
    default = {}
}

output "project_name" {
  value = aws_codebuild_project.project_main.name
}