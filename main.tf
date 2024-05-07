
provider "aws" {
  region = var.region
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

resource "aws_security_group" "instance" {
  name   = "mongodb-security-group"
  vpc_id = data.aws_vpc.selected.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "g35_subnet_group" {
  name       = "g35_subnet_group"
  subnet_ids = data.aws_subnet_ids.g35_subnets.ids

  tags = {
    Name = "g35"
  }
}

provider "mongodbatlas" {
  public_key = "abcdefgh"
  private_key  = "abcdefgh-abcd-1234-5678-abcdefghijkl"
}

module "mongodb" {
  source                = "../../"
  version               = "~>0.0.1" // Change to the required version.
  environment           = "test-environment"
  app_name              = "test-app"
  aws_profile           = "my-aws-profile"
  env_type              = "non-prod"
  atlasprojectid        = "1234567890abcdefghijklmno"
  atlas_region          = "US_EAST_1"
  atlas_num_of_replicas = 3
  backup_on_destroy     = true
  restore_on_create     = true
  allowed_envs          = "mv_env"
  db_name               = "test-db"
  init_db_environment   = "src-db"
  init_db_aws_profile   = "src-aws-profile"
  ip_whitelist          = ["127.0.0.1","127.0.0.2","127.0.0.3"]
  atlas_num_of_shards         = 1
  mongo_db_major_version      = "4.2"
  disk_size_gb                = 10
  provider_disk_iops          = 1000
  provider_volume_type        = "STANDARD"
  provider_instance_size_name = "M10"
  aws_vpce = ""
  db_subnet_group_name   = aws_db_subnet_group.g35_subnet_group.name
  vpc_security_group_ids = [aws_security_group.instance.id]
}
