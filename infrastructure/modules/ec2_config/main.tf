resource "aws_instance" "instance1" {
  ami             = "ami-03839f1dba75bb628"
  instance_type   = "t2.micro"
  subnet_id       = var.subnet1.id
  key_name        = var.ssh_key.ssh_key_name
  security_groups = [var.main_security_group]
  tags = {
    Name = "lab13_w01",
    Server_Role = "web",
    Project = "lab13"
  }
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname lab13_w01
              EOF
}

resource "aws_instance" "instance2" {
  ami             = "ami-03839f1dba75bb628"
  instance_type   = "t2.micro"
  subnet_id       = var.subnet2.id
  security_groups = [var.main_security_group]
  key_name        = var.ssh_key.ssh_key_name
  tags = {
    Name = "lab13_b01",
    Server_Role = "backend",
    Project = "lab13"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname lab13_b01
              EOF

}