#!/bin/bash
sudo dnf -y install docker
sudo service docker start
sudo docker run -u root -p 80:8080 --name jenkins-server -d -v /var/run/docker.sock:/var/run/docker.sock -v /home/ec2-user:/var/jenkins jenkins/jenkins:lts
# // Add Docker GPG
sudo docker exec jenkins-server apt update
sudo docker exec jenkins-server apt install -y ca-certificates curl
sudo docker exec jenkins-server install -m 0755 apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -d /etc/apt/keyrings
sudo docker exec jenkins-server curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo docker exec jenkins-server chmod a+r /etc/apt/keyrings/docker.asc
# Add repository
sudo docker exec jenkins-server echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo '$VERSION_CODENAME') stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo docker exec jenkins-server apt-get update
sudo docker exec jenkins-server apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
