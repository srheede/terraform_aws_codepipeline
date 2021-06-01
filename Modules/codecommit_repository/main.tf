resource "aws_codecommit_repository" "repository_main" {
    repository_name = var.repository_name
    tags = var.tags
}