resource "aws_instance" "app_server" {
  ami = "ami-063d43db0594b521b"
  instance_type = "t2.medium"
  key_name = "vockey"
  subnet_id = aws_subnet.main_a.id
  security_groups = [aws_security_group.web_sg.id]
  tags = {
     Name = "Jenkins"
  }
  
  connection {
    type = "ssh"
    host = sefl.public_ip
    user = "ec2-user"
    private_key = file("labsuser.pem")
  }

  provisioner "file" {
     source = "setup-jenkins.sh"
     destination = "/tmp/setup-jenkins.sh"
  }
  
  provisioner "remote-exec" {
     inline = [
        "chmod +x /tmp/setup-jenkins.sh",
        "/tmp/setup-jenkins.sh"
     ]
   }
}

