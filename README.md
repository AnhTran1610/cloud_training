# A "simple" cloud diagram used for internal training

## Diagram

![simple_infras](https://github.com/hieuldt/cloud_training/blob/main/Picture1.png)

Still have lots of work to do

## Prerequirement:
```
aws ec2 create-key-pair --key-name server_key --query "KeyMaterial" --output text > server_key.pem
aws ec2 describe-key-pairs --key-name server_key
```
Run Terraform
```
terraform init
terraform apply
```
