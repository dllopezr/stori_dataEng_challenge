resource "aws_s3_bucket" "stori_raw_images" {
    bucket = "stori-raw-images-dllr"
    tags = {
        Name = "stori-raw-images-dllr"
    }
}

resource "aws_s3_bucket" "stori_artifacts" {
    bucket = "stori-artifacts-dllr"
    tags = {
        Name = "stori-artifacts-dllr"
    }
}

resource "aws_s3_bucket" "stori_thumbnail_images" {
    bucket = "stori-thumbnail-images-dllr"
    tags = {
        Name = "stori-thumbnail-images-dllr"
    }
}
