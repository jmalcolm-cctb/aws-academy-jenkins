#!/bin/bash
sudo dnf -y install docker
sudo service docker start
sudo docker run -u root -p 80:8080 --name jenkins-server -d -v /var/run/docker.sock:/var/run/docker.sock -v /home/ec2-user:/var/jenkins jenkins/jenkins:lts
sudo docker exec jenkins-server apt update
sudo docker exec jenkins-server apt install -y docker.io
