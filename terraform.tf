# ================================================================
# Terraform Config
# ================================================================

terraform {
  required_version = "1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }

  backend "s3" {}
}

# ================================================================
# Provider Config
# ================================================================

provider "aws" {
  region = var.REGION

  default_tags {
    tags = {
      SystemName = var.SYSTEM_NAME
    }
  }
}

# ================================================================
# Variables
# ================================================================

variable "REGION" {
  type     = string
  nullable = false
}

variable "SYSTEM_NAME" {
  type     = string
  nullable = false
}

variable "S3_BUCKET" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "S3_KEY_PREFIX" {
  type     = string
  nullable = false
}

# ================================================================
# Modules
# ================================================================

module "base" {
  source = "./modules/layer"

  source_directory = "layers/base"
  parameter_name   = "BaseLayer"

  s3_bucket     = var.S3_BUCKET
  s3_key_prefix = var.S3_KEY_PREFIX
}

# ================================================================
# Outputs
# ================================================================

output "ssm_parameter_name_base_layer" {
  value = module.base.ssm_parameter_name_layer_arn
}
