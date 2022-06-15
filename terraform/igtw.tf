resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.dani_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}