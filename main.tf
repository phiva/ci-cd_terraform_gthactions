provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "teste" {
    bucket = "bucket-s3-terraform-ghtactions100185"
}

resource "aws_s3_bucket_ownership_controls" "teste" {
    bucket = aws_s3_bucket.teste.id
    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "teste" {
    depends_on = [ aws_s3_bucket_ownership_controls.teste ]

    bucket = aws_s3_bucket.teste.id
    acl = "private"
}

resource "aws_s3_bucket_public_access_block" "teste" {
    bucket = aws_s3_bucket.teste.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_teste" {
    bucket = aws_s3_bucket.teste.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_kms_key" "minhachave" {
    description = "Chave a ser utilizada para protecão dos objetos do bucket"
    enable_key_rotation = true
    deletion_window_in_days = 14
}

resource "aws_s3_bucket_server_side_encryption_configuration" "teste" {
    bucket = aws_s3_bucket.teste.id

    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.minhachave.arn
        sse_algorithm = "aws:kms"
      }
    }
}