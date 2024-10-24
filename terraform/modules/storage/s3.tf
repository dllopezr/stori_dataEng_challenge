resource "aws_s3_bucket" "stori_raw_images" {
    bucket = "stori-raw-images-dllr"
    tags = {
        Name = "stori-raw-images-dllr"
    }
}