resource "aws_api_gateway_rest_api" "stori_thumbnail_generator" {
  name        = "stori_thumbnail_generator"
  description = "API that allows to convert an image into a thumbnail"
  binary_media_types = ["image/jpeg"]
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "upload_image" {
  rest_api_id = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  parent_id   = aws_api_gateway_rest_api.stori_thumbnail_generator.root_resource_id
  path_part   = "upload_image"
}

resource "aws_api_gateway_method" "post_upload_image" {
  rest_api_id   = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  resource_id   = aws_api_gateway_resource.upload_image.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_store_original_images_integration" {
  rest_api_id              = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  resource_id              = aws_api_gateway_resource.upload_image.id
  http_method              = aws_api_gateway_method.post_upload_image.http_method
  integration_http_method  = "POST"
  type                     = "AWS"
  uri                      = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:921082494404:function:store_original_images/invocations"
  passthrough_behavior     = "WHEN_NO_TEMPLATES"
  request_templates = {
    "image/jpg" = <<EOF
{
  "body": "$input.body",
  "isBase64Encoded": true
}
EOF
  }

}

resource "aws_lambda_permission" "stori_thumbnail_generator_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-2:921082494404:function:store_original_images"
  principal     = "apigateway.amazonaws.com"
}


resource "aws_api_gateway_deployment" "stori_thumbnail_generator_deployment" {
  rest_api_id = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  stage_name  = "v1"
}

resource "aws_api_gateway_stage" "stori_thumbnail_generator_deployment_v1_stage" {
  rest_api_id = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  deployment_id = aws_api_gateway_deployment.stori_thumbnail_generator_deployment.id
  stage_name = "v1" 
}

resource "aws_api_gateway_integration_response" "stori_thumbnail_generator_response" {
  rest_api_id = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  resource_id = aws_api_gateway_resource.upload_image.id
  http_method = aws_api_gateway_method.post_upload_image.http_method
  status_code = "200"
  content_handling = "CONVERT_TO_BINARY"
  response_templates = {
    "application/json" = "Empty"
  }
}


resource "aws_api_gateway_method_response" "post_upload_image_response" {
  rest_api_id = aws_api_gateway_rest_api.stori_thumbnail_generator.id
  resource_id = aws_api_gateway_resource.upload_image.id
  http_method = aws_api_gateway_method.post_upload_image.http_method
  status_code = "200"
  response_models = {
   "application/json" = "Empty"
  }
}