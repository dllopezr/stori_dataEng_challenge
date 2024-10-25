# Overview

Thumbnail generator: You make a post request to https://ui7ykbfwc1.execute-api.us-east-2.amazonaws.com/dev/upload_image with your image path, and you receive a pre-signed s3 URL that can be pasted on your browser to display the thumbnail

# Architecture

API GATEWAY ---> LAMBDA_FUNCTION ---> RAW_IMAGES_BUCKET, THUMBNAIL_IMAGES_BUCKET

Disclaimer: I'm having issues generating the pre-signed URL for the THUMBNAIL_IMAGES_BUCKET, so to make this repo usable, I'm putting the thumbnail images on the RAW_IMAGES_BUCKET and generating the pre-signed URL from there.


# Usage

curl --request POST -H "Content-Type: image/jpg" --data-binary "@path_to_your_file.jpg" https://ui7ykbfwc1.execute-api.us-east-2.amazonaws.com/dev/upload_image


# Impromevents

To make the most of this thumbnail generator, I propose the following improvements:

- You can persist the metadata in a Database (e.g DynamoDB) to avoid reprocessing the same image multiple times
- You can create an integration to attach the lambda function with SimpleEmailService and send an email to the user with the ID/URL of the image.
- For analytics purposes, you can create an ETL to bring usage data to a Data Lake (S3 -> Athena)
- For massive amounts of petitions or large files, you can attach an SQS to the lambda function and change the invoke type to allow asynchronous processing
- Additionally, for massive amounts of petitions it would be a good idea to change the lambda for ECS's clusters under a Load Balancer. Serverless options like Lambda can get very expensive when the usage scales exponentially.
- You can use SNS to send alerts about failures in the requests.
- About the management of the infrastructure: it'll be much better to use outputs and variables to reference the resources in Terraform, instead of hardcoding the arn's. This will allow seamless scaling and operability when the architecture begins to grow.
- To decouple the components, a good approach could be to use two lambdas: One for storing the original images and the second to perform the thumbnail generator. We can use a s3 event to trigger the execution of the second lambda function.
