sudo apt update && sudo apt install -y wget gnupg2 lsb-release curl && wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb && sudo dpkg -i percona-release_latest.generic_all.deb && sudo apt update && sudo percona-release setup pxc80 && sudo apt install -y percona-xtradb-cluster-client && sudo apt install -y proxysql2