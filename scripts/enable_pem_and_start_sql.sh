sudo chmod 400 *.pem
sudo chown mysql.mysql *.pem
sudo mv *.pem /var/lib/mysql
sudo systemctl start mysql