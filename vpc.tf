resource "aws_vpc" "jh-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "JH-vpc"
  }
}

resource "aws_subnet" "jh-public-subnet-1" {
  vpc_id            = aws_vpc.jh-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "jh-public-subnet-1"
  }
}

resource "aws_subnet" "jh-public-subnet-2" {
  vpc_id            = aws_vpc.jh-vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "jh-public-subnet-2"
  }
}

resource "aws_subnet" "jh-private-subnet-1" {
  vpc_id            = aws_vpc.jh-vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "jh-private-subnet-1"
  }
}

resource "aws_subnet" "jh-private-subnet-2" {
  vpc_id            = aws_vpc.jh-vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "jh-private-subnet-2"
  }
}

resource "aws_db_subnet_group" "jh-rds-subnet-group" {
  name       = "jh-rds-subnet-group"
  subnet_ids = [aws_subnet.jh-private-subnet-1.id, aws_subnet.jh-private-subnet-2.id]
}

resource "aws_internet_gateway" "jh-IGW" {
  vpc_id = aws_vpc.jh-vpc.id
  tags = {
    Name = "jh-IGW"
  }
}

resource "aws_security_group" "jh-public-sg" {
  vpc_id = aws_vpc.jh-vpc.id
  name   = "jh-public-sg"
  tags = {
    Name = "jh-public-sg"
  }
}

resource "aws_security_group_rule" "jh-public-sg-SSH" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jh-public-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "jh-public-sg-HTTP" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jh-public-sg.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "jh-private-sg" {
  vpc_id = aws_vpc.jh-vpc.id
  name   = "jh-private-sg"
  tags = {
    Name = "jh-private-sg"
  }
}

resource "aws_security_group_rule" "jh-private-sg-rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  security_group_id        = aws_security_group.jh-private-sg.id
  source_security_group_id = aws_security_group.jh-public-sg.id
  lifecycle {
    create_before_destroy = true
  }
}
