** Greetz to CDG for getting the original version of this developed. **

The purpose of this repository is to quickly instantiate an environment used to demonstrate Cloudflare's core web reliability, performance, and security, abilities.

The Prerequisites and Instructions are critical to making this work.

## What it builds today:
* Google Cloud Platform - spins up 2 linux hosts in different availability zones. This is so we can demonstrate Load Balancing primarily.
  * The servers are running Nginx, and have a small static website on each.
  * They also run Docker with containers for mendhak/http-https-echo, clue/json-server, and kennethreitz/httpbin
  * Cloudflare Tunnel (argo) is installed and configured automatically.
* DNS records are configured for each of the servers in GCP.
* Load Balancer is configured to distribute traffic across each of the GCP regions.
* Web Application Firewall is configured to enable the managed rule sets and configure a few specific policies.
* Rate Limiting is configured for demonstration purposes.
* Spectrum is configured for SSH.
* Workers is configured with Party Parrot for fun and CORS for API demonstrations.

## Prerequisites

1. Install and login to Google Cloud Platform, https://cloud.google.com/sdk/gcloud/. Once installed and authenticated to the team account you are st.
2. Install Terraform, https://learn.hashicorp.com/tutorials/terraform/install-cli.
3. Have a Cloudflare account with administrative priviledges, AND ideally have a domain not being used for anything else. This allows you to comfortably destroy the configurations and rebuild any time. You will also need to entitle Enterprise Zones, Spectrum, Rate Limiting, Workers, and potentially Teams.

## Instructions

1. Clone the repository ``` git clone https://github.com/freshdemo/cloudflare-demo-core.git```,  and cd into the directory.


2. Edit terraform.tfvars. You can specify the Cloudflare zone, account, email, and token. The **GCP project is globalse-198312**. Finally you can specify the GCP zones. The ones I've selected are some of their green powered zones.


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
