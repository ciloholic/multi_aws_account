# MeiSEI
resource "aws_iam_user" "mei_sei" {
  name          = "MeiSEI"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "mei_sei" {
  user = aws_iam_user.mei_sei.name
  groups = [
    aws_iam_group.administrators.name,
  ]
}
