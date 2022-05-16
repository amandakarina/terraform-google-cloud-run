# Using Cloud Run with Shared VPC
Code for POC to test if GCP serverless (Cloud Run) works well with a Shared VPC on other project. And also to have an example on how to do that.

## Steps to create the POC
- PROJECTS:
    - {Project 1} for network
        - VPC, Firewall, Shared VPC, IAM policies
    - {Project 2} for serverless
        - Only Cloud Run for now!!!
- SHARED VPC:
    - Create the VPC on {Project 1} with the sub-net
        - Sub-net IP should be "10.10.10.0/28"
    - Create the Shared VPC from {Project 1} to {Project 2}
- FIREWALL and CONNECTOR
    - On {Project 1} create the firewall as needed
        - https://cloud.google.com/run/docs/configuring/shared-vpc-service-projects#firewall-rules-shared-vpc
    - Still on {Project 1} grant permissions to the SA
        - https://cloud.google.com/run/docs/configuring/shared-vpc-service-projects#grant-permissions
- SERVERLESS VPC ACCESS
    - On {Project 2} enable "Serverless VPC Access API"
    - Still on {Project 2} Create a Serverless VPC Access
        - https://cloud.google.com/vpc/docs/configure-serverless-vpc-access#create-connector
- CLOUD RUN
    - Configure Cloud Run to use the connectors
        - https://cloud.google.com/vpc/docs/configure-serverless-vpc-access#cloud-run

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
export ORG_ID=<YOUR-ORG-ID>
export FOLDER_ID=<YOUR-FOLDER-ID>
export SA_EMAIL=<YOUR-SA-EMAIL>

gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/compute.networkAdmin"
gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/resourcemanager.projectIamAdmin"
gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/serviceusage.serviceUsageAdmin"
gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/vpcaccess.admin"
gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/compute.xpnAdmin"
gcloud resource-manager folders add-iam-policy-binding ${FOLDER_ID} --member="serviceAccount:${SA_EMAIL}" --role="roles/compute.securityAdmin"
```

## How to run
- PERMISSIONS:
    - For the POC you can use your own accout wich is the owner of the projects.
    - For the real scenario the account or SA should have this permissions:
        - One
- Copy and rename the file ```terraform.examples.tfvars``` to ```terraform.tfvars``` and then replace with your own variables for your environment.
    - Use the command bellow to get the 



gcloud projects list --filter="$(gcloud config get-value project)" --format="value(PROJECT_NUMBER)"