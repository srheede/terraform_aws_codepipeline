variable codebuild_project_name {
    type = string
    default = "project_main"
}

variable codecommit_repository_name {
    type = string
    default = "repository_main"
}

variable artifact_location {
    type = string
}

variable artifact_arn {
    type = string
}

variable codecommit_repository_arn {
    type = string
}

variable tags {
    type = any
    default = {}
}
