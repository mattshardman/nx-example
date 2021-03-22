#!/bin/bash
b=`aws s3 ls | grep githublearn-tf-state`

echo "Bucket: $b"

if [ "$b" == "" ] ; then
    echo "Creating terraform backend in s3"
    cd terraform
    pwd
    terraform init
    terraform plan
    terraform apply -auto-approve
fi