import base64
import io
from typing import Dict
import uuid
import boto3
from botocore.config import Config
from PIL import Image


s3 = boto3.client(
   's3',
)

def store_original_image(
        raw_images_bucket: str, 
        event: Dict
) -> str:
    """
    Stores an original image in an S3 bucket and returns a presigned URL for accessing the image.

    Args:
        raw_images_bucket (str): The name of the S3 bucket where the image will be stored.
        event (Dict): A dictionary containing the image data. 
                      It is expected to have a key 'body' with a base64-encoded string representation of the image.

    Returns:
        str: The s3 key of the stored original image.
    """

    image_uuid = uuid.uuid4()
    file_content = base64.b64decode(event['body'])
    s3_key = f'{image_uuid}.jpg'
    s3_response = s3.put_object(
            Bucket=raw_images_bucket, 
            Key=s3_key,
            Body=file_content,
            ContentType='image/jpeg'
    )

    return s3_key

def create_thumbnail_image(
        raw_images_bucket: str,
        s3_key: str,
        thumbnail_images_bucket: str
) -> str:
    """
    Creates a thumbnail image from an existing image stored in an S3 bucket and uploads it to another S3 bucket.

    Args:
        raw_images_bucket (str): The name of the S3 bucket containing the original image.
        s3_key (str): The S3 key of the original image that will be used to retrieve it.
        thumbnail_images_bucket (str): The name of the S3 bucket where the thumbnail will be stored.

    Returns:
        str: A presigned URL for accessing the stored thumbnail image, valid for 1 hour (3600 seconds).
    """
    response = s3.get_object(Bucket=raw_images_bucket, Key=s3_key)
    image_data = response['Body'].read()

    size=(128, 128)
    with Image.open(io.BytesIO(image_data)) as img:
        img.thumbnail(size)

        thumbnail_buffer = io.BytesIO()
        img.save(thumbnail_buffer, format='JPEG')
        thumbnail_buffer.seek(0)

    thumbnail_key = f"thumbnail_{s3_key}"
    s3.put_object(
        Bucket=thumbnail_images_bucket, 
        Key=thumbnail_key,
        Body=thumbnail_buffer.getvalue(),
        ContentType='image/jpeg'
    )
    return thumbnail_key

def generate_presigned_url(
        bucket_name: str, 
        thumbnail_key: str, 
        expiration: int = 3600
) -> str:
    """
    Generate a presigned URL to share an S3 object.

    Args:
        bucket_name (str): The name of the S3 bucket.
        thumbnail_key (str): The key (path) of the object within the S3 bucket.
        expiration (int, optional): Time in seconds for the presigned URL to remain valid. Default is 3600 (1 hour).

    Returns:
        str: A presigned URL to access the specified S3 object. 
    """
    # Initialize the S3 client

    # Generate the presigned URL
    response = s3.generate_presigned_url(
        'get_object',
        Params={'Bucket': bucket_name, 'Key': thumbnail_key},
        ExpiresIn=expiration,
    )
    return response
