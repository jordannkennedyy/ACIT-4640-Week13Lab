data "aws_region" "current" {
}    

# we will be saving that state of terrafom to an S3 bucket so that other people can access
# an S3 bucket is an object store
# lives locally, and you sent an https request to access
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  # the following will prevent the bucket from being destroyed. In production
  # this is a good idea, but for this demo we want to be able to destroy the 
  # bucket
#  lifecycle {
#    prevent_destroy = true
#  }

  # the following will force the bucket to be destroyed when using terraform destroy
  # This isn't ideal for production
  force_destroy = true

}

# turning on versioning fo the bucket, we can reach back intime and access the state to restore if something happens
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# turning on encryption so it is encrypted at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

# using the bucket when we create the aws s3 public access block
# this is the file that we will create inside the bucket
# can only be accesss by the aws cli in this instance
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# noSQL name value store (dynamodb) using it here to have a single attibute = lock id
# lockid: id (string)
# this will control access to the S3 bucket with the state file in it
# we will also use the key value in another terrform configuration
# why use dynamodb? -> concurrent access, allowing multiple people to access the file at the same time
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# using this to configure a terraform file
# it will configure terraform in a different project
# output file into backend_config.tf
# output of this file can be commited to git

# put this in git v

resource "local_file" "tf_backend_config" {
  content = <<EOF
terraform {
    backend "s3" {
        bucket         = "${var.bucket_name}"
        key            = "terraform.tfstate"
        dynamodb_table = "${var.dynamodb_name}"
        region         =  "${data.aws_region.current.name}" 
        encrypt        = true
    }
}
EOF

  filename = "../infrastructure/backend_config.tf"

}
