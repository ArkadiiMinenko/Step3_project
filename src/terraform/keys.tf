resource "tls_private_key" "jenkins" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content              = tls_private_key.jenkins.private_key_pem
  filename             = "${path.module}/../ansible/files/jenkins-key-arkadii.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins-key-arkadii"
  public_key = tls_private_key.jenkins.public_key_openssh
}