#! /bin/sh
yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
docker run -d --name srv2-nginx -p 80:80 -d nginx:1.23.1