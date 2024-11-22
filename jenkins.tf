resource "aws_instance" "app_server" {
  ami = "ami-063d43db0594b521b"
  instance_type = "t2.medium"
  key_name = aws_key_pair.secret_key.key_name
  subnet_id = aws_subnet.main_a.id
  security_groups = [aws_security_group.web_sg.id]
  tags = {
     Name = "Jenkins"
  }

  provisioner "remote-exec" {
     inline = [
        "sudo dnf -y install docker",
        "sudo service docker start",
        "sudo docker run -u root -p 80:8080 --name jenkins-server -d -v /var/run/docker.sock:/var/run/docker.sock -v /home/ec2-user:/var/jenkins jenkins/jenkins:lts",
        "sudo docker exec jenkins-server apt update",
        "sudo docker exec jenkins-server apt install -y curl",
        "sudo docker exec jenkins-server curl -fsSL https://get.docker.com -o get-docker.sh",
        "sudo docker exec jenkins-server sh get-docker.sh",
        "sudo docker exec jenkins-server chmod 666 /var/run/docker.sock"
     ]
   }

   connection {
     type = "ssh"
     host = self.public_ip
     user = "ec2-user"
     private_key = tls_private_key.jkey.private_key_pem 
   }

   provisioner "local-exec" {
      command = "./getkey.sh"
   }
}
