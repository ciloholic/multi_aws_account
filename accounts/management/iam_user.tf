# owner
resource "aws_iam_user" "owner" {
  name          = "owner"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "owner_admin" {
  user       = aws_iam_user.owner.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
