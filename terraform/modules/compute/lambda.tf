resource "aws_lambda_function" "store_original_images" {
  function_name = "store_original_images"
  s3_bucket   = "stori-artifacts-dllr"
  s3_key      = "lambda_function.zip"
  handler     = "lambda_function.lambda_handler"
  role        = "arn:aws:iam::921082494404:role/store_original_images"
  runtime     = "python3.10"
  timeout     = 60
  memory_size = 256
  layers      = ["arn:aws:lambda:us-east-2:770693421928:layer:Klayers-p310-Pillow:8"]
}