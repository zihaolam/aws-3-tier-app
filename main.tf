provider "aws" {
  region  = "ap-southeast-1"
  profile = "localzone-project"
}

resource "aws_instance" "web_servers" {
  count           = 2
  ami             = var.ubuntu_ami
  instance_type   = "t3.medium"
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.web_server_sg.id]
  tags = {
    Name = "webserver-${count.index + 1}"
  }
}

resource "aws_instance" "db_servers" {
  count           = 3
  ami             = var.ubuntu_ami
  private_ip      = ["10.0.0.1"]
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.web_server_sg.id]
  tags = {
    Name = "dbserver-${count.index + 1}"
  }
}

resource "aws_instance" "load_balancer" {
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.public_subnet.*.id, 0)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.load_balancer_sg.id]
  tags = {
    Name = "load_balancer"
  }
}

resource "aws_instance" "file_server" {
  count           = 3
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.load_balancer_sg.id]
  tags = {
    Name = "fileserver-${count.index + 1}"
  }
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 500
  }
}

resource "aws_instance" "bastion_host" {
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.public_subnet.*.id, 0)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.bastion_host_sg.id]
  tags = {
    Name = "bastionhost-server"
  }
}

# NAT
resource "aws_instance" "nat_gateway_instance" {
  subnet_id       = element(aws_subnet.public_subnet.*.id, 0)
  ami             = var.ubuntu_ami
  key_name        = var.general_key_pair
  instance_type   = "t3.medium"
  security_groups = [aws_security_group.nat_gateway_instance_sg.id]
  user_data       = <<-EOL
      echo '#!/bin/sh
      echo 1 > /proc/sys/net/ipv4/ip_forward
      iptables -t nat -A POSTROUTING -s 10.0.0.0/16 -j MASQUERADE
      ' | sudo tee /etc/network/if-pre-up.d/nat-setup
      sudo chmod +x /etc/network/if-pre-up.d/nat-setup
      sudo /etc/network/if-pre-up.d/nat-setup
  EOL

  tags = {
    Name = "natgateway-server"
  }
}
