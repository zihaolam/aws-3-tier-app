# step 1

## Install on all nodes

```
#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install -y wget gnupg2 lsb-release curl
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo dpkg -i percona-release_latest.generic_all.deb
sudo apt update
sudo percona-release setup pxc80
sudo apt install -y percona-xtradb-cluster
```

```
sudo systemctl stop mysql
```

## Bootstrap First Node

Paste inside /etc/mysql/my.cnf and replace the node's ip addresses

```
[mysqld]

datadir=/var/lib/mysql
user=mysql

# Path to Galera library
wsrep_provider=/usr/lib/libgalera_smm.so

# Cluster connection URL contains the IPs of node#1, node#2 and node#3
wsrep_cluster_address=gcomm://<node_1_ip>,<node_2_ip>,<node_3_ip>

# In order for Galera to work correctly binlog format should be ROW
binlog_format=ROW

# Using the MyISAM storage engine is not recommended
default_storage_engine=InnoDB

# This InnoDB autoincrement locking mode is a requirement for Galera
innodb_autoinc_lock_mode=2

# Node #1 address
wsrep_node_address=<current_node_ip>

# SST method
wsrep_sst_method=xtrabackup-v2

# Cluster name
wsrep_cluster_name=my_ubuntu_cluster
```

```
    sudo systemctl start mysql@bootstrap.service
```

## Transfer Keys to other 2 nodes

Transfer all keys from /var/lib/mysql to the other 2 nodes, using file transfer methods\

```
sudo chown -R mysql.mysql /var/lib/mysql/\*.pem
```

---

**NOTE**

Make sure the owner of the keys are mysql.mysql

---

## Setup other nodes

Paste inside the other node's /etc/mysql/my.cnf

```
[mysqld]

datadir=/var/lib/mysql
user=mysql

# Path to Galera library
wsrep_provider=/usr/lib/libgalera_smm.so

# Cluster connection URL contains the IPs of node#1, node#2 and node#3
wsrep_cluster_address=gcomm://<node_1_ip>,<node_2_ip>,<node_3_ip>

# In order for Galera to work correctly binlog format should be ROW
binlog_format=ROW

# Using the MyISAM storage engine is not recommended
default_storage_engine=InnoDB

# This InnoDB autoincrement locking mode is a requirement for Galera
innodb_autoinc_lock_mode=2

# Node #1 address
wsrep_node_address=<current_node_ip>

# SST method
wsrep_sst_method=xtrabackup-v2

# Cluster name
wsrep_cluster_name=my_ubuntu_cluster
```

```
sudo systemctl start mysql
```

---

**NOTE**

This command is different than the first node, there is no bootstrap.service here

---
