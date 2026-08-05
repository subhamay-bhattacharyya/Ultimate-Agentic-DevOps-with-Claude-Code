# Terraform state backend configuration.
#
# On first run, leave this block commented out and use local state:
#   1. terraform init
#   2. terraform apply   (this creates the S3 bucket / other resources)
#
# Once you have created a dedicated S3 bucket for storing Terraform state
# (and, optionally, a DynamoDB table for state locking), uncomment the
# backend block below, fill in the bucket name, then run:
#   3. terraform init -migrate-state
#
# terraform {
#   backend "s3" {
#     bucket       = "REPLACE_WITH_YOUR_TERRAFORM_STATE_BUCKET"
#     key          = "subhamay-bhattacharyya/terraform.tfstate"
#     region       = "us-east-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
