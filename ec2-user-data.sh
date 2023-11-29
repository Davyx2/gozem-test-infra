#!/bin/bash

set -e
logdir=/var/log

logfile=${logdir}/_setup.log
#-- docker
sudo apt-get update -y 
sudo apt-get install awscli amazon-ecr-credential-helper -y
curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh get-docker.sh 
sudo usermod -a -G docker $USER 
sudo docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres:13

# # #--- docker compose
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

#  #------aws ecr --------------
#  # Add credential helper to pull from ECR
sudo chmod 0700 $DOCKER_CONFIG >> $logfile
sudo touch $DOCKER_CONFIG/config.json >> $logfile
sudo chown -R $USER:$USER $DOCKER_CONFIG >> $logfile
sudo echo '{"credsStore": "ecr-login"}' >> $DOCKER_CONFIG/config.json

#sudo docker run  --name nginx  -d  -p 80:80 nginx
sudo docker run  --name api  -d  -p 80:8080 --name api -e NODE_DOCKER_PORT=80 -e "137975280244.dkr.ecr.eu-west-3.amazonaws.com/gozem-test"  DB_URL=