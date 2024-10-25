import base64
import json
import uuid
import boto3
from PIL import Image

BUCKET_NAME = 'stori-raw-images-dllr'
s3 = boto3.client('s3')

def lambda_handler(event, context):

    image_uuid = uuid.uuid4()
    file_content = base64.b64decode(event['body'])
    s3_key = f'{image_uuid}.jpg'


    try:
        s3_response = s3.put_object(
            Bucket=BUCKET_NAME, 
            Key=s3_key, 
            Body=file_content,
            ContentType='image/jpeg')

        presigned_url = s3.generate_presigned_url('get_object',
            Params={'Bucket': BUCKET_NAME, 'Key': s3_key},
            ExpiresIn=3600)

    except Exception as e:
        raise IOError(e)
    return {
        'statusCode': 200,
        'body': {
            'file_path': s3_key,
            'url': presigned_url
        }
    }