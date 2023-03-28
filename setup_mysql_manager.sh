#! /bin/bash

cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_7.6.6-1ubuntu18.04_amd64.deb
sudo mkdir /var/lib/mysql-cluster/
sudo touch /var/lib/mysql-cluster/config.ini
echo "
    [ndbd default]
    # Options affecting ndbd processes on all data nodes:
    NoOfReplicas=2	# Number of replicas

    [ndb_mgmd]
    # Management process options:
    hostname=10.0.3.10 # Hostname of the manager
    datadir=/var/lib/mysql-cluster 	# Directory for the log files

    [ndbd]
    hostname=10.0.3.11 # Hostname/IP of the first data node
    NodeId=2			# Node ID for this data node
    datadir=/usr/local/mysql/data	# Remote directory for the data files

    [ndbd]
    hostname=10.0.4.10 # Hostname/IP of the second data node
    NodeId=3			# Node ID for this data node
    datadir=/usr/local/mysql/data	# Remote directory for the data files

    [mysqld]
    # SQL node options:
    hostname=10.0.3.10 # In our case the MySQL server/client is on the same instance as the cluster manager
" | sudo tee -a /var/lib/mysql-cluster/config.ini > /dev/null
sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini
sudo pkill -f ndb_mgmd
sudo touch /etc/systemd/system/ndb_mgmd.service
echo '
    [Unit]
    Description=MySQL NDB Cluster Management Server
    After=network.target auditd.service

    [Service]
    Type=forking
    ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=process
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
' | sudo tee -a /etc/systemd/system/ndb_mgmd.service > /dev/null
sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd
sudo systemctl status ndb_mgmd

cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar
mkdir install
tar -xvf mysql-cluster_7.6.6-1ubuntu18.04_amd64.deb-bundle.tar -C install/
cd install
sudo apt update
sudo apt install libaio1 libmecab2
sudo dpkg -i mysql-common_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-client_7.6.6-1ubuntu18.04_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-cluster-community-server_7.6.6-1ubuntu18.04_amd64.deb
sudo dpkg -i mysql-server_7.6.6-1ubuntu18.04_amd64.deb
sudo touch /etc/mysql/my.cnf
echo '
    !includedir /etc/mysql/conf.d/
    !includedir /etc/mysql/mysql.conf.d/

    [mysqld]
    # Options for mysqld process:
    ndbcluster                      # run NDB storage engine

    [mysql_cluster]
    # Options for NDB Cluster processes:
    ndb-connectstring=10.0.3.10  # location of management server

    [client]
    user=root
    password=root
' | sudo tee -a /etc/mysql/my.cnf > /dev/null
sudo systemctl restart mysql
sudo systemctl enable mysql