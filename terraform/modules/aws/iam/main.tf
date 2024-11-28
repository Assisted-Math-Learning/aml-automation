resource "aws_iam_user" "s3_user" {
  name = "${var.building_block}-${var.env}-s3-user"
  path = "/"
}

resource "aws_iam_access_key" "s3_user_key" {
  user       = aws_iam_user.s3_user.name
  depends_on = [aws_iam_user.s3_user]
}

resource "aws_iam_user_policy_attachment" "s3_user_policy" {
  user       = aws_iam_user.s3_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
