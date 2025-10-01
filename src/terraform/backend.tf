terraform {
  backend "s3" {
    bucket         = "jenkins-tfstate-arkadii"
    key            = "infra/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}