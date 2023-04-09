#! /bin/bash

# only for one of the nodes
sudo gluster peer probe gluster1

sudo gluster volume \
 create main_volume replica 2\
 gluster0.localzone.com:/shared-storage \
 gluster1.localzone.com:/shared-storage force

sudo gluster volume start main_volume