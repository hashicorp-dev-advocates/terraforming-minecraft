// Create an AWS S3 bucket.
resource "aws_s3_bucket" "example" {
  // Set the bucketname.
  bucket = "my-example-bucket"

  // Enable versioning.
  versioning {
    enabled = true
  }

  // Add tags.
  tags = {
    Name        = "Example bucket"
    Environment = "Dev"
  }
}

// Set the bucket to private.
resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}
