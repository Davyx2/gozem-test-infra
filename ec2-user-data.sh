#!/bin/bash

set -e
logdir=/var/log

logfile=${logdir}/_setup.log
#-- docker
sudo apt-get update -y
sudo apt-get install awscli amazon-ecr-credential-helper -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo service docker start
sudo docker run  --name nginx  -d  -p 80:80 nginx
#  #------aws ecr --------------
#  # Add credential helper to pull from ECR
sudo mkdir -p /home/ubuntu/.docker
sudo chmod 0700 /home/ubuntu/.docker
sudo touch /home/ubuntu/.docker/config.json
sudo chown -R ubuntu:ubuntu /home/ubuntu/.docker
sudo echo '{"credsStore": "ecr-login"}' >> /home/ubuntu/.docker/config.json

aws ecr get-login-password --region eu-west-3 | sudo docker login --username AWS --password-stdin 137975280244.dkr.ecr.eu-west-3.amazonaws.com


sudo docker  pull 137975280244.dkr.ecr.eu-west-3.amazonaws.com/gozem-test
sudo docker run  --name api  -d  -p 8080:8080 --name api -e NODE_DOCKER_PORT=8080  -e  DB_URL="" 137975280244.dkr.ecr.eu-west-3.amazonaws.com/gozem-test
sudo service docker start