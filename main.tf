provider "aws" {
  region  = var.region
  profile = "DynamoDB"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["g35-vpc"]
  }
}

data "aws_subnet_ids" "g35_subnets" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_subnet" "g35_subnet" {
  for_each = data.aws_subnet_ids.g35_subnets.ids
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.g35_subnet : s.cidr_block]
}

resource "aws_dynamodb_table" "pagamento" {

  name         = var.table_name
  billing_mode = var.table_billing_mode
  hash_key     = "pagamento-id"
  attribute {
    name = "pagamento-id"
    type = "S"
  }

  tags = {
    environment = "${var.environment}"
  }

 vpc_endpoint_id = data.aws_vpc.selected.id
 route_table_id  = data.aws_vpc.selected.main_route_table_id
}
