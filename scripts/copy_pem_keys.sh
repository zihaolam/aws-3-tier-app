sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/ca-key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/ca.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/client-cert.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/client-key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/private_key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/public_key.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/server-cert.pem ubuntu@10.0.5.10:~
sudo scp -o StrictHostKeyChecking=no -i ./key.pem /var/lib/mysql/server-key.pem ubuntu@10.0.5.10:~
