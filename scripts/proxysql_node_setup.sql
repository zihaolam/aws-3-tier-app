CREATE USER 'proxysql'@'%' IDENTIFIED WITH mysql_native_password by 'ProxySQLPa55';
GRANT USAGE ON *.* TO 'proxysql'@'%';
CREATE USER 'sbuser'@'10.0.3.11' IDENTIFIED with mysql_native_password BY 'sbpass';
GRANT ALL ON *.* TO 'sbuser'@'10.0.3.11';
