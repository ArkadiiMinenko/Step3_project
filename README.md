# Step3 Project — Jenkins Master/Worker with Terraform & Ansible

## 🔧 Infrastructure (Terraform)

- **S3 Bucket** — stores `terraform.tfstate`.
- **VPC** — with a public subnet (Jenkins master) and a private subnet (Jenkins worker).
- **Internet Gateway + NAT Gateway** — for Jenkins master Internet access and Jenkins worker outbound via NAT.
- **EC2**:
  - Jenkins master — on-demand instance in the public subnet.
  - Jenkins worker — spot instance in the private subnet.
- **Security Groups** — open ports:
  - **22** — SSH
  - **80** — HTTP (Nginx → Jenkins)
  - **8080** — Jenkins (internal access)
- **SSH key** — created with `tls_private_key` and used for Ansible connections.

## ⚙️ Jenkins Master (Ansible)

- Install Jenkins from the official repository.
- Install nginx.
- Configure nginx reverse proxy for Jenkins access via port 80.
- Install Ansible on Jenkins master, which configures the Jenkins worker.
- Copy SSH key for access to the private IP of the Jenkins worker.

## 🧩 Jenkins Worker (Ansible)

- Installation of:
  - **Java 17 Amazon Corretto**
  - **Docker**
  - **Git**
- After this, the Jenkins master EC2 executes `playbook_worker.yml` over SSH.

## 🐳 Jenkins Pipeline (port 80)

- Clone `forStep2` folder using sparse-checkout.
- Build Docker image.
- Run tests.
- Push image to Docker Hub.
- Deploy the container to port 80.
- Credentials added via Jenkins UI:
  - `github-creds` — GitHub access token.
  - `dockerhub-creds` — DockerHub login/password.

## 📁 Project Structure

```text
Step3_project/
├── screens/                          # Screenshots of all steps
├── src/
│   ├── ansible/                      # Ansible configuration
│   │   ├── files/
│   │   │   ├── inventory_worker.ini
│   │   │   └── jenkins-key-arkadii.pem
│   │   ├── templates/
│   │   │   └── default.conf          # Nginx reverse proxy
│   │   ├── inventory.ini
│   │   └── playbook.yml              # Main Ansible playbook
│   ├── bootstrap/                    # S3 bucket creation
│   │   ├── bootstrap_s3.tf
│   │   ├── terraform_aply.txt
│   │   └── terraform_destroy.txt
│   ├── jenkins pipelines/            # Jenkins pipelines in .txt format
│   │   ├── Dockerhub access check pipeline.txt
│   │   ├── Github access check pipeline.txt
│   │   └── Final pipeline.txt        # Full pipeline with deploy
│   └── terraform/                    # Main infrastructure
│       ├── backend.tf
│       ├── keys.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform_aply.txt
│       ├── terraform_destroy.txt
│       └── variables.tf
├── .gitignore
