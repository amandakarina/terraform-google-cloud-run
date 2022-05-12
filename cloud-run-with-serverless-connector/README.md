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