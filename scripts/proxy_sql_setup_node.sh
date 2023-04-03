CREATE USER 'proxysql'@'%' IDENTIFIED WITH mysql_native_password by 'ProxySQLPa55';
GRANT USAGE ON *.* TO 'proxysql'@'%';

CREATE USER 'sbuser'@'10.0.3.11' identified with mysql_native_password by 'sbpass';
GRANT all on *.* TO 'sbuser'@'10.0.3.11';

CREATE DATABASE sbtest;