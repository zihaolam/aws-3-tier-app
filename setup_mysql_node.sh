#! /bin/bash

#1. 
cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb
sudo apt update
sudo apt install libclass-methodmaker-perl




#2. 
sudo dpkg -i mysql-cluster-community-data-node_7.6.6-1ubuntu18.04_amd64.deb
sudo touch /etc/my.cnf
echo '
    [mysql_cluster]
    # Options for NDB Cluster processes:
    ndb-connectstring=10.0.3.10  # location of cluster manager
' | sudo tee -a '/etc/my.cnf' > /dev/null
sudo mkdir -p /usr/local/mysql/data
sudo ndbd
sudo pkill -f ndbd
sudo touch /etc/systemd/system/ndbd.service

echo '
    [Unit]
    Description=MySQL NDB Data Node Daemon
    After=network.target auditd.service

    [Service]
    Type=forking
    ExecStart=/usr/sbin/ndbd
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=process
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
' | sudo tee -a /etc/systemd/system/ndbd.service > /dev/null
sudo systemctl daemon-reload
sudo systemctl enable ndbd
sudo systemctl start ndbd
sudo systemctl status ndbd