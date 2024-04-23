
The purpose of this repository is to quickly instantiate an environment used to demonstrate Snyk's integrations with on-premise solutions. Specifically this currently builds a Bitbucket container. Many of these solutions do not run well (or at all) on ARM. There's no reason for everyone to figure this out for the first time, and it means you can also destroy the system when finished using it to save costs.

The Prerequisites and Instructions are critical to making this work.


## What it builds today:
* Instantiate and update a linux host in GCP with a public IP address, ```origin.tf``` and ```nat_ip.tf```.
* Create firewall rules to permit the most relevant ports for these applications from your home IP ```firewallrules.tf```.
* Install Docker, ```server.tpl```.
* Build a Bitbucket container, found in the folder ```bitbucket```. The reason for the custom container is that it enables SSL (required for Broker), and generates SSL certificates that are imported into the container, ```server.tpl```.
* Build a Snyk Broker container for Bitbucket container, ```server.tpl```.


## Prerequisites

1. Install and login to Google Cloud Platform, https://cloud.google.com/sdk/gcloud/.
2. Install Terraform, https://learn.hashicorp.com/tutorials/terraform/install-cli.
3. Sign up for a Bitbucket account if you don't have one.

## Instructions


1. Clone the repository ``` git clone https://github.com/stephen-snyk/snyk-box-bitbucket.git```,  and cd into the directory. There is a .gitignore file so your tfvars and plan should not be pushed to the SCM.


2. Edit terraform.tfvars 

    * You can change the region, zone, and machine type but the ones in the sample file work fine.
    * Set the Bitbucket credentials here so that we can automate the Broker configuration. So just be sure that when you are are able to login to Bitbucket and creating the user you create an account with the credentials set here.
    * Setting your public IP address in ```my_subnet``` will keep the environment more secure and our security team happier.


3. Instantiate Terraform

    The commands below will upgrade the Terraform provider (i.e. we're using the GCP provider), initialize the working directory where you cloned the GitHub repository, and create the plan used to build the environment.

    ```
    terraform init -upgrade
    terraform init
    terraform plan --out=first.plan
    ```

    Typically errors generated when creating the plan are from incorrect variables in the terraform.tfvars, or if you've edited the variables in server.tpl or the origin.tf.


4. Apply the Terraform plan

    This builds everything in the plan in GCP. It takes less than 5 minutes. And once completed you should see a message about the apply completing and get some of the networking information as output.

    ```
    terraform apply "first.plan"
    ```

5. Complete Bitbucket Configuration

    Bitbucket will shortly be available on the public IP address output to your console on port 443, so navigate to that in a web browser.

    They only provide temporary licenses for Bitbucket server/datacenter, which is another good reason to be able to create/destroy this at will. You will be prompted to sign into your Bitbucket account to generate the temporary license.

    When prompted to create a Bitbucket user use the credentials set in your tfvars file in step 2.


6. Destroy everything

    ```
    terraform destroy
    ```

If you need to make changes it is best to practice the changes in the running environment. Once you know how to implement them correctly destroy the currently running environment first. Then make changes (most likely in server.tpl) and go back to ```terraform plan```, ```terraform apply``` to build the new version.
