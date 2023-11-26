# #!/bin/bash
# logdir=/var/log

# logfile=${logdir}/_setup.log
# #-- docker
# sudo apt-get update -y 
# curl -fsSL https://get.docker.com -o get-docker.sh 
# sudo sh get-docker.sh 
# sudo usermod -a -G docker $USER 
# sudo docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres:13

# #--- docker compose
# DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
# mkdir -p $DOCKER_CONFIG/cli-plugins
# curl -SL https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
# chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
# #--- nginx
# sudo apt-get install nginx -y 
# sudo systemctl start nginx 
# sudo systemctl enable nginx 
# #--- certbot
# sudo apt install certbot python3-certbot-nginx -y 
# #------aws ecr --------------
# sudo apt-get install awscli amazon-ecr-credential-helper
# # Add credential helper to pull from ECR
# sudo mkdir -p ~/.docker 
# sudo chmod 0700 ~/.docker
# sudo touch ~/.docker/config.json
# sudo chown -R $USER:$USER .docker/
# sudo echo '{"credsStore": "ecr-login"}' >> ~/.docker/config.json


