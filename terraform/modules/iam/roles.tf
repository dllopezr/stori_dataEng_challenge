resource "aws_iam_role" "lambda_store_original_images" {
  name               = "store_original_images"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::921082494404:policy/put_stori_raw_images",
    "arn:aws:iam::921082494404:policy/create_logs"
    ]
}