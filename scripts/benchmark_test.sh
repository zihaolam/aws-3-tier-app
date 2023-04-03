#! /bin/bash

sysbench \
--mysql-user=sbuser \
--mysql-password=sbpass \
--mysql-db=sbtest \
--mysql-host=10.0.3.11 \
--mysql-port=6033 \
--table-size=10000 \
--threads=4 \
--time=20 \
--events=0 \
--report-interval=1 \
--db-driver=mysql \
/usr/share/sysbench/oltp_read_write.lua prepare


sysbench \
--mysql-user=sbuser \
--mysql-password=sbpass \
--mysql-db=sbtest \
--mysql-host=10.0.3.11\
--mysql-port=6033 \
--table-size=10000 \
--threads=4 \
--time=20 \
--events=0 \
--report-interval=1 \
--db-driver=mysql \
/usr/share/sysbench/oltp_read_write.lua run