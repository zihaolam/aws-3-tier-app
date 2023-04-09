#! /bin/bash

echo "
10.0.3.120 gluster0.localzone.com gluster0
10.0.4.120 gluster1.localzone.com gluster1
" | sudo tee -a /etc/hosts > /dev/null

sudo apt update -y \ 
&& sudo apt install -y software-properties-common \ 
&& sudo add-apt-repository -y ppa:gluster/glusterfs-7 \ 
&& sudo apt update \ 
&& sudo apt install -y glusterfs-client

sudo mkdir /storage-pool

sudo mount -t glusterfs gluster0.localzone.com:main_volume /storage-pool