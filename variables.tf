# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "table_name" {
  description = "Dynamodb table name (space is not allowed)"
  default     = "pagamento-service-table"
}

variable "table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  default     = "PAY_PER_REQUEST"

}

variable "environment" {
  description = "Name of environment"
  default     = "g35"
}
