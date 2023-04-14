// data latest windows ami
data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-*Japanese*Base*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "allow_all_egress" {
  name        = "allow_all_egress"
  description = "Allow all egress"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// create windows ec2
resource "aws_instance" "windows" {
  ami                  = data.aws_ami.windows.id
  instance_type        = "t3.micro"
  subnet_id            = var.subnet_id
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2.name
  security_groups = [
    aws_security_group.allow_all_egress.id,
  ]
}
