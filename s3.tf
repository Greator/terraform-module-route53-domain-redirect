resource "random_string" "hash" {
  length  = 16
  special = false
}

#tfsec:ignore:AWS001 tfsec:ignore:AWS002
resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${var.zone}-${lower(random_string.hash.result)}"
  acl    = "public-read"

  website {
    redirect_all_requests_to = var.target_url
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
}
