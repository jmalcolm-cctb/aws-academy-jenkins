resource "aws_instance" "app_server" {
  ami = "ami-063d43db0594b521b"
  instance_type = "t2.medium"
  key_name = "vockey"
  subnet_id = aws_subnet.main_a.id
  security_groups = [aws_security_group.web_sg.id]
  tags = {
     Name = "Jenkins"
  }

  provisioner "remote-exec" {
     inline = [
        "sudo dnf -y install docker",
        "sudo service docker start",
        "sudo docker run -u root --privileged -p 80:8080 --name jenkins-server -d -v /var/run/docker.sock:/var/run/docker.sock -v /home/ec2-user:/var/jenkins jenkins/jenkins:lts",
        "sudo docker exec jenkins-server apt update",
        "sudo docker exec jenkins-server apt install -y docker.io"
     ]
   }

   connection {
     type = "ssh"
     host = self.public_ip
     user = "ec2-user"
     private_key = file("labsuser.pem")
   }
}
