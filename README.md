# Hiive eks cluster

## Description

This repo creates a private eks cluster, a vpc, two subnets, one nodegroup, iam policies, role attachment, security group

Policy has been attached to the node group so that it can handle the autoscaling and is able to create load balancers (autoscaler/service should be created in kubernetes as well)

The eks cluster created by this repo wont be accessible publicly.

A simple nginx application is deployed to the cluster.
I also have attached plan file in the repo (which is not good practise)
I have commented backend S3 part (S3 should be created before this cluster). It is better to isolate the S3 bucket from the terraform code.
## Command to create cluster

```
# init terraform
$ terraform init

# check the resources that will be created
$ terraform plan -out=planFile


# if you are satisfied with terraform plan
$ terraform apply planFile -auto-approve

# delete resources (be cautious)
$ terraform destroy

```

