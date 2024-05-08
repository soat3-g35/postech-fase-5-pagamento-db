# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {

  cloud {
    organization = "DevopsFiapSoat3-G35"
    workspaces {
      name = "postech-fase-4-pagamento-db"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }
  }
}
