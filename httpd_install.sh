#!/bin/bash
sudo yum update
sudo yum install httpd -y
sudo cp /home/ec2-user/sourceweb/index.html /var/www/html
sudo chmod 644 /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd
