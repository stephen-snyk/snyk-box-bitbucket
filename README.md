
The purpose of this repository is to quickly instantiate an environment used to demonstrate Snyk's integrations with on-premise solutions. Many of which do not run well or at all on ARM. There's no reason for everyone to figure this out for the first time, and it means you can also destroy the system when finished using it to save costs.

The Prerequisites and Instructions are critical to making this work.


## What it builds today:
* Instantiate and update a linux host in GCP.
* Create a firewall rule to permit the most relevant ports for these applications from your home IP.
* Install Docker.
* Build a Bitbucket container.
* Build a Snyk Broker for Bitbucket container.


## Prerequisites

1. Install and login to Google Cloud Platform, https://cloud.google.com/sdk/gcloud/.
2. Install Terraform, https://learn.hashicorp.com/tutorials/terraform/install-cli.

## Instructions

1. Clone the repository ``` git clone https://github.com/stephen-snyk/snyk-box.git```,  and cd into the directory.


2. Edit terraform.tfvars. You can change the zone and machine type.


3. Upgrade the Terraform provider, initialize the working directory where you cloned the GitHub repository, and create the plan used to build the environment.

```
terraform init -upgrade
terraform init
terraform plan --out=first.plan
```

Typically errors generated when creating the plan are from incorrect variables in the terraform.tfvars, or if you've edited the variables in server.tpl or the origin.tf.


4. Apply the Terraform plan.

```
terraform apply "first.plan"
```

5. Destroy everything.

```
terraform destroy
```
