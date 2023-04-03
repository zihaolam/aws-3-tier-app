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
}

resource "aws_instance" "db_load_balancer" {
  ami             = var.ubuntu_ami
  private_ip      = var.dbmanager_private_ip
  subnet_id       = element(aws_subnet.private_subnet.*.id, 0)
  instance_type   = "t3.medium"
  key_name        = var.general_key_pair
  security_groups = [aws_security_group.db_server_sg.id]
  tags = {
    Name = "db_load_balancer"
  }

  user_data = <<-EOL
    !# /bin/bash
    sudo apt update
    sudo apt install -y wget gnupg2 lsb-release curl
    wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
    sudo dpkg -i percona-release_latest.generic_all.deb
    sudo apt update
    sudo percona-release setup pxc80
    sudo apt install -y percona-xtradb-cluster-client
    sudo apt sudo apt install -y proxysql2

    EOL

    depends_on = [
      aws_instance.nat_gateway_instance
    ]
}

# resource "aws_instance" "db_manager" {
#   ami             = var.ubuntu_ami
#   private_ip      = var.dbmanager_private_ip
#   subnet_id       = element(aws_subnet.private_subnet.*.id, 0)
#   instance_type   = "t3.medium"
#   key_name        = var.general_key_pair
#   security_groups = [aws_security_group.db_manager_sg.id]
#   tags = {
#     Name = "dbmanager"
#   }

#   #   user_data = <<-EOL
#   #     #! /bin/bash
#   #     cd ~
#   #     wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo mkdir /var/lib/mysql-cluster
#   #     sudo touch /var/lib/mysql-cluster/config.ini
#   #     echo "
#   #         [ndbd default]
#   #         # Options affecting ndbd processes on all data nodes:
#   #         NoOfReplicas=2	# Number of replicas

#   #         [ndb_mgmd]
#   #         # Management process options:
#   #         hostname=${var.dbmanager_private_ip} # Hostname of the manager
#   #         datadir=/var/lib/mysql-cluster 	# Directory for the log files

#   #         [ndbd]
#   #         hostname=${element(var.dbservers_private_ip, 0)} # Hostname/IP of the first data node
#   #         NodeId=2			# Node ID for this data node
#   #         datadir=/usr/local/mysql/data	# Remote directory for the data files

#   #         [ndbd]
#   #         hostname=${element(var.dbservers_private_ip, 1)} # Hostname/IP of the second data node
#   #         NodeId=3			# Node ID for this data node
#   #         datadir=/usr/local/mysql/data	# Remote directory for the data files

#   #         [mysqld]
#   #         # SQL node options:
#   #         hostname=${var.dbmanager_private_ip} # In our case the MySQL server/client is on the same Droplet as the cluster manager
#   #     " | sudo tee -a /var/lib/mysql-cluster/config.ini > /dev/null
#   #     sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
#   #     sudo pkill -f ndb_mgmd
#   #     sudo touch /etc/systemd/system/ndb_mgmd.service
#   #     echo '
#   #         [Unit]
#   #         Description=MySQL NDB Cluster Management Server
#   #         After=network.target auditd.service

#   #         [Service]
#   #         Type=forking
#   #         ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
#   #         ExecReload=/bin/kill -HUP $MAINPID
#   #         KillMode=process
#   #         Restart=on-failure

#   #         [Install]
#   #         WantedBy=multi-user.target
#   #     ' | sudo tee -a /etc/systemd/system/ndb_mgmd.service > /dev/null
#   #     sudo systemctl daemon-reload
#   #     sudo systemctl enable ndb_mgmd
#   #     sudo systemctl start ndb_mgmd
#   #     sudo systemctl status ndb_mgmd

#   #     cd ~
#   #     wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
#   #     mkdir install
#   #     tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/
#   #     cd install
#   #     sudo apt update
#   #     sudo apt install libaio1 libmecab2
#   #     sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
#   #     sudo touch /etc/mysql/my.cnf
#   #     echo '
#   #         !includedir /etc/mysql/conf.d/
#   #         !includedir /etc/mysql/mysql.conf.d/

#   #         [mysqld]
#   #         # Options for mysqld process:
#   #         ndbcluster                      # run NDB storage engine

#   #         [mysql_cluster]
#   #         # Options for NDB Cluster processes:
#   #         ndb-connectstring=${var.dbmanager_private_ip}  # location of management server

#   #         [client]
#   #         user=root
#   #         password=root
#   #     ' | sudo tee -a /etc/mysql/my.cnf > /dev/null
#   #     sudo systemctl restart mysql
#   #     sudo systemctl enable mysql
#   #   EOL

# }

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
  private_ip      = element(var.fileservers_private_ip, count.index)
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
  subnet_id         = element(aws_subnet.public_subnet.*.id, 0)
  ami               = var.ubuntu_ami
  key_name          = var.general_key_pair
  instance_type     = "t3.medium"
  security_groups   = [aws_security_group.nat_gateway_instance_sg.id]
  source_dest_check = false
  user_data         = <<-EOL
    #! /bin/bash
    sudo sysctl -q -w net.ipv4.ip_forward=1 net.ipv4.conf.ens5.send_redirects=0
    sudo iptables -t nat -C POSTROUTING -o ens5 -s 10.0.0.0/16 -j MASQUERADE 2> /dev/null
    sudo iptables -t nat -A POSTROUTING -o ens5 -s 10.0.0.0/16 -j MASQUERADE
  EOL

  tags = {
    Name = "natgateway-server"
  }
}
