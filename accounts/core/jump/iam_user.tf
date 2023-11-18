# 山田太郎
resource "aws_iam_user" "tarou_yamada" {
  name          = "TarouYAMADA"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "tarou_yamada" {
  user = aws_iam_user.tarou_yamada.name
  groups = [
    aws_iam_group.administrators.name,
  ]
}
