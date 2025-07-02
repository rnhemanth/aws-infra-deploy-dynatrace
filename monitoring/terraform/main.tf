locals {
  environment = lower(var.environment)
  #dynamically pick up the installer package for environment type
  agent_folder = var.tags.environment == "prd" ? "../agent/prod/" : "../agent/nonprod/"
}

module "default_tags" {
  source = "git@github.com:emisgroup/emisx-platform-engineering.git//modules/default-tags?ref=tf-module-default-tags@v0.3.2"
  #checkov:skip=CKV_TF_1:This is a trusted internal resource

  application      = "dyn-activegate"
  portfolio        = "product-platform-portfolio"
  environment      = local.environment
  product          = "internal"
  service          = "activegate"
  service_location = "internal"
  speciality       = "emisx-platform"
  cost_centre      = "emis-x"
  business_unit    = "primary-care"
  owner            = "group:emisx-platform-engineering"
  software_version = var.service_version
  aws_account_id   = var.account_id
}

resource "aws_s3_bucket" "emisdynatracebucket" {
  #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV2_AWS_61:Ensure that an S3 bucket has a lifecycle configuration
  #checkov:skip=CKV2_AWS_6:Ensure that S3 bucket has a Public Access block
  #bucket        = "${var.tags.environment}-${var.tags.service}-s3-bucket-emisdynatrace${var.awsaccount.id}"

  ###update
  #bucket        = "${var.tags.environment}-${var.tags.service}-s3-bucket-emisdynatrace"
  ###bucket        = "${var.environment}-${var.tags.service}-s3-bucket-emisdynatrace"
  #bucket        = "${var.tags.environment}-${var.tags.service}-s3-bucket-emisdynatrace"
  bucket = "${var.tags.environment}-${var.tags.service}-s3-bucket-${var.account_id}"

  force_destroy = true
  tags          = module.default_tags.tags
}



resource "aws_s3_bucket_versioning" "emisdynatrace_root_versioning" {
  bucket = aws_s3_bucket.emisdynatracebucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


#resource "aws_s3_object" "agent_install_files" {
#  for_each = fileset("../agent/", "*")
#  bucket   = aws_s3_bucket.emisdynatracebucket.id
#  key      = "agent/${each.value}"
#  source   = "../agent/${each.value}"
#  etag     = filemd5("../agent/${each.value}")
#  tags     = {}
#}


#updated reource type based on vars.tag.environment tag.
resource "aws_s3_object" "agent_install_files" {
  for_each = fileset(local.agent_folder, "*")
  bucket   = aws_s3_bucket.emisdynatracebucket.id
  key      = "agent/${each.value}"
  source   = "${local.agent_folder}${each.value}"
  etag     = filemd5("${local.agent_folder}${each.value}")
  tags     = {}
}



resource "aws_s3_object" "agent_config_files" {
  for_each = fileset("../config/", "*")
  bucket   = aws_s3_bucket.emisdynatracebucket.id
  key      = "config/${each.value}"
  source   = "../config/${each.value}"
  etag     = filemd5("../config/${each.value}")
  tags     = {}
}


resource "aws_s3_object" "scripts" {
  for_each = fileset("../scripts/", "*")
  bucket   = aws_s3_bucket.emisdynatracebucket.id
  key      = "scripts/${each.value}"
  source   = "../scripts/${each.value}"
  etag     = filemd5("../scripts/${each.value}")
  tags     = {}
}

output "dynatrace-integration-roles" {
  value = try(module.aws_intg[0].role_arn, "")
}
