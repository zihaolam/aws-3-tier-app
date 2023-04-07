#!/bin/bash

echo "
10.0.3.120 gluster0.localzone.com gluster0
10.0.4.120 gluster1.localzone.com gluster1
" | sudo tee -a /etc/hosts > /dev/null

sudo apt update -y \
&& sudo apt install -y software-properties-common \
&& sudo add-apt-repository -y ppa:gluster/glusterfs-7 \
&& sudo apt update -y \
&& sudo apt install -y glusterfs-server \
&& sudo systemctl status glusterd.service


# only for one of the nodes
sudo gluster peer probe gluster1

sudo gluster volume \
 create main_volume replica 2\
 gluster0.localzone.com:/shared-storage \
 gluster1.localzone.com:/shared-storage force

sudo gluster volume start main_volume