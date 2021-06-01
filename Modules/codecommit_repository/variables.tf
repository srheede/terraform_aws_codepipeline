variable repository_name {
    type = string
    default = "repository_main"
}

variable tags {
    type = any
    default = {}
}

output "repository_name" {
  value = aws_codecommit_repository.repository_main.repository_name
}

output "repository_arn" {
  value = aws_codecommit_repository.repository_main.arn
}
