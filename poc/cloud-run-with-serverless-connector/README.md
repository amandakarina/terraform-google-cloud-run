# Using Cloud Run with Shared VPC

Code for POC to test if GCP serverless (Cloud Run) works well with a Shared VPC on other project. And also to have an example on how to do that.

## Steps to create the POC

- PROJECTS:
  - {Project 1} for network
    - VPC, Firewall, Shared VPC, IAM policies
  - {Project 2} for serverless
    - Serverless VPC access
    - Only ```Cloud Run``` for now!!!
- SHARED VPC:
  - Create the VPC on {Project 1} with the sub-net
    - Sub-net IP should be "10.10.10.0/28"
  - Create the Shared VPC from {Project 1} to {Project 2}
- FIREWALL
  - On {Project 1} create the firewall as needed
    - <https://cloud.google.com/run/docs/configuring/shared-vpc-service-projects#firewall-rules-shared-vpc>
  - Still on {Project 1} grant permissions to the SA
    - <https://cloud.google.com/run/docs/configuring/shared-vpc-service-projects#grant-permissions>
- SERVERLESS VPC ACCESS and CONNECTOR
  - On {Project 2} enable "Serverless VPC Access API"
  - Still on {Project 2} Create a Serverless VPC Access
    - <https://cloud.google.com/vpc/docs/configure-serverless-vpc-access#create-connector>
- CLOUD RUN
  - Configure Cloud Run to use the connectors
    - <https://cloud.google.com/vpc/docs/configure-serverless-vpc-access#cloud-run>

## Versions

- terraform
  - ```>= 0.13```
- google
  - ```~> 3.77```
- google-beta
  - ```~> 3.77```

## Service Account

To provision the resources of this example, create a privileged service account,
where the service account key cannot be created.

In addition, consider using Cloud Monitoring to alert on this service account's activity.

Grant the following roles to the service account:

```sh
export FOLDER_ID=<YOUR-FOLDER-ID>
export SA_EMAIL=<YOUR-SA-EMAIL>

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/compute.networkAdmin"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/resourcemanager.projectIamAdmin"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/serviceusage.serviceUsageAdmin"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/vpcaccess.admin"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/compute.xpnAdmin"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/compute.securityAdmin"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/run.developer"

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/iam.serviceAccountUser"
```

## How to run

- BEFORE START, run the commands to grant the roles for the SA.
- Copy and rename the file ```terraform.examples.tfvars``` to ```terraform.tfvars``` and then replace with your own variables for your environment.
  - You can use the command bellow to get the ```"serverless_project_number"```:

```sh
gcloud projects list --filter="$(gcloud config get-value project)" --format="value(PROJECT_NUMBER)"
```

- Run the terraform commands to deploy.

```sh
terraform init
terraform plan
terraform apply
```

## Deleting project

Most of the times when trying to delete the VPC project you get an error regarding the liens (xpn). When this happen you should run those commands to delete the project properly:

- Open the terminal on the project that you want to delete

```sh
gcloud config set project ${vpc_project_id}
```

- Get the liens that is blocking the deletion and save the name to use later

```sh
gcloud alpha resource-manager liens list
```

- Delete the lien

```sh
gcloud alpha resource-manager liens delete ${lien_name}
```
