sudo apt update -y \
&& sudo apt install -y software-properties-common \
&& sudo add-apt-repository -y ppa:gluster/glusterfs-7 \
&& sudo apt update \
&& sudo apt install -y glusterfs-client