provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "teste" {
    bucket = "bucket-s3-terraform-ghtactions100185"
}