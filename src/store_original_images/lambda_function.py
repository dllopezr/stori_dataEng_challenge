import json
import thumbnail_generator
import boto3

RAW_IMAGES_BUCKET = 'stori-raw-images-dllr'
THUMBNAIL_IMAGES_BUCKET = 'stori-thumbnail-images-dllr'

def lambda_handler(event, context):

    original_image_s3_key = thumbnail_generator.store_original_image(
        RAW_IMAGES_BUCKET,
        event
    )

    thumbnail_key = thumbnail_generator.create_thumbnail_image(
        RAW_IMAGES_BUCKET,
        original_image_s3_key,
        RAW_IMAGES_BUCKET
    )

    response = thumbnail_generator.generate_presigned_url(
        RAW_IMAGES_BUCKET,
        thumbnail_key
    )


    return {
        'statusCode': 200,
        'body': {
            'url': response
        }
    }