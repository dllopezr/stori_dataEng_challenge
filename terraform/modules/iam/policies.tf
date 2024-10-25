## assume role policies

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

## managed policies

resource "aws_iam_policy" "put_stori_raw_images" {
  name        = "put_stori_raw_images"
  description = "This policy grants put objects on the stori-raw-images-dllr bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::stori-raw-images-dllr/*"
            ]
        }
    ]
  })
}