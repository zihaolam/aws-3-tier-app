#!/bin/bash

sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/ca-key.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/ca.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/client-cert.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/client-key.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/private_key.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/public_key.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/server-cert.pem ubuntu@10.0.3.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/server-key.pem ubuntu@10.0.3.10:~

sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/ca-key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/ca.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/client-cert.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/client-key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/private_key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/public_key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/server-cert.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/server-key.pem ubuntu@10.0.5.10:~

sudo systemctl start mysql@bootstrap.service && \

sudo mysql -u root -Bse "
CREATE USER 'proxysql'@'%' IDENTIFIED WITH mysql_native_password by 'ProxySQLPa55';
GRANT USAGE ON *.* TO 'proxysql'@'%';
CREATE USER 'sbuser'@'10.0.3.11' IDENTIFIED with mysql_native_password BY 'sbpass';
GRANT ALL ON *.* TO 'sbuser'@'10.0.3.11';"
