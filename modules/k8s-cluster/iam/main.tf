resource "aws_iam_role" "k8s" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "k8s" {
  role       = aws_iam_role.k8s.name
  policy_arn = var.policy_arn
}

output "iam_role_name" {
  value = aws_iam_role.k8s.name
}
