
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

resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.11"
  username               = "postgres"
  password               = "postgres"
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "MyPostgresDB"
  }
}
