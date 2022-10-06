#! /bin/sh
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
docker run -d --name srv1-apache -p 80:80 -d httpd:2.4.54