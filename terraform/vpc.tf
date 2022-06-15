resource "aws_vpc" "dani_vpc" {
  cidr_block = "172.32.0.0/16"

  tags = {
    Name = "dani"
  }
}