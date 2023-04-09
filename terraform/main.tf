provider "aws" {
  region  = "ap-southeast-1"
  profile = "localzone-project"
}

resource "aws_instance" "web_servers" {
  count           = 2
  ami             = var.ubuntu_ami
  instance_type   = "t3.medium"
  private_ip      = element(var.webservers_private_ip, count.index)
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.web_server_sg.id]
  tags = {
    Name = "webserver-${count.index + 1}"
  }
  depends_on = [
    aws_instance.nat_gateway_instance
  ]

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    prepend_user_data = "",
    append_user_data  = <<-EOL
    docker-compose -f ~/app/app-frontend/docker-compose.yml up -d
    EOL
  }))
}

resource "aws_instance" "db_servers" {
  count           = 3
  ami             = var.ubuntu_ami
  private_ip      = element(var.dbservers_private_ip, count.index)
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.db_server_sg.id]
  tags = {
    Name = "dbserver-${count.index + 1}"
  }
  depends_on = [
    aws_instance.nat_gateway_instance
  ]

  user_data = base64encode(templatefile("./user_data/db.tftpl", {}))
}

resource "aws_instance" "db_load_balancer" {
  ami             = var.ubuntu_ami
  private_ip      = var.dbmanager_private_ip
  subnet_id       = element(aws_subnet.private_subnet.*.id, 0)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.db_load_balancer_sg.id]
  tags = {
    Name = "db_load_balancer"
  }

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    prepend_user_data = "",
    append_user_data  = base64encode(templatefile("./user_data/db_proxy.tfpl", {}))
  }))

  depends_on = [
    aws_instance.nat_gateway_instance
  ]
}

resource "aws_instance" "app_server" {
  count           = 2
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  private_ip      = element(var.appservers_private_ip, count.index)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.app_server_sg.id]
  tags = {
    Name = "appserver-${count.index + 1}"
  }

  depends_on = [
    aws_instance.nat_gateway_instance
  ]

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    prepend_user_data = "",
    append_user_data  = <<-EOL
    docker-compose -f ~/app/app-backend/docker-compose.yml up -d
    EOL
  }))
}

resource "aws_instance" "web_load_balancer" {
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.public_subnet.*.id, 0)
  instance_type   = "t3.medium"
  private_ip      = var.webserverlb_private_ip
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.web_load_balancer_sg.id]
  tags = {
    Name = "web_load_balancer"
  }


  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    prepend_user_data = "",
    append_user_data  = base64encode(templatefile("./user_data/weblb.sh", {}))
  }))
}

resource "aws_instance" "app_load_balancer" {
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.public_subnet.*.id, 0)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  private_ip      = var.appserverlb_private_ip
  security_groups = [aws_security_group.app_load_balancer_sg.id]
  tags = {
    Name = "app_load_balancer"
  }

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    prepend_user_data = "",
    append_user_data  = base64encode(templatefile("./user_data/applb.sh", {}))
  }))
}

resource "aws_instance" "file_server" {
  count           = 2
  ami             = var.ubuntu_ami
  subnet_id       = element(aws_subnet.private_subnet.*.id, count.index)
  private_ip      = element(var.fileservers_private_ip, count.index)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.file_server_sg.id]
  tags = {
    Name = "fileserver-${count.index + 1}"
  }

  depends_on = [
    aws_instance.nat_gateway_instance
  ]

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    prepend_user_data = "",
    append_user_data  = base64encode(templatefile("./user_data/fileserver.sh", {}))
  }))

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
  private_ip      = var.bastionhost_private_ip
  tags = {
    Name = "bastionhost-server"
  }

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", { append_user_data = "", prepend_user_data = "" }))
}

# NAT
resource "aws_instance" "nat_gateway_instance" {
  subnet_id         = element(aws_subnet.public_subnet.*.id, 0)
  ami               = var.ubuntu_ami
  key_name          = var.general_key_pair
  private_ip        = var.natgateway_private_ip
  instance_type     = "t3.medium"
  security_groups   = [aws_security_group.nat_gateway_instance_sg.id]
  source_dest_check = false

  user_data = base64encode(templatefile("./user_data/healthcheck_server.tftpl", {
    append_user_data  = "",
    prepend_user_data = <<-EOL
    #! /bin/bash
    sudo sysctl -q -w net.ipv4.ip_forward=1 net.ipv4.conf.ens5.send_redirects=0
    sudo iptables -t nat -C POSTROUTING -o ens5 -s 10.0.0.0/16 -j MASQUERADE 2> /dev/null
    sudo iptables -t nat -A POSTROUTING -o ens5 -s 10.0.0.0/16 -j MASQUERADE
  EOL
  }))

  tags = {
    Name = "natgateway-server"
  }
}
