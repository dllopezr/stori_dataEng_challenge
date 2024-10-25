resource "aws_lambda_function" "store_original_images" {
  function_name = "store_original_images"
  s3_bucket   = "stori-artifacts-dllr"
  s3_key      = "lambda_store_original_images.zip"
  handler     = "lambda_function.lambda_handler"
  role        = "arn:aws:iam::921082494404:role/store_original_images"
  runtime     = "python3.10"
  timeout     = 60
  memory_size = 256
}