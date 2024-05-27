# MediaWiki Deployment Automation

## Prerequisites
- Terraform installed
- Ansible installed
- Azure CLI configured with appropriate credentials
- Azure DevOps or another CI/CD tool set up

## Steps to Run

1. Clone the repository:
   ```sh
   git clone https://github.com/mishraswastika/Thoughtworks_Test.git
   cd mediawiki-terraform
Initialize and apply Terraform:

sh
Copy code
terraform init
terraform apply -auto-approve
Run Ansible playbook:

sh
Copy code
ansible-playbook -i $(terraform output -raw public_ip), playbook.yml
Access MediaWiki:

Open a web browser and navigate to the public IP address of the instance.

