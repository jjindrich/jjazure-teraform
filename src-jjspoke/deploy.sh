#!/bin/sh
echo "Setting environment variables for Terraform"
tenant=$(az account show -o tsv --query tenantId)
subscription=$(az account show -o tsv --query id)

# az ad sp create-for-rbac -n jjtf --role="Contributor" --scopes="/subscriptions/${subscription}"
clientApplicationId=$(az keyvault secret show --vault-name jjkeyvault --name tfClientApplicationId -o tsv --query value)
clientSecret=$(az keyvault secret show --vault-name jjkeyvault --name tfClientSecret -o tsv --query value)

export ARM_SUBSCRIPTION_ID=$subscription
export ARM_TENANT_ID=$tenant
export ARM_CLIENT_ID=$clientApplicationId
export ARM_CLIENT_SECRET=$clientSecret

subscription_spoke="c96358c2-e8a3-43ed-89c6-add1aaa99441"

# wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
# sudo unzip ./terraform_0.12.29_linux_amd64.zip -d /usr/local/bin/

echo "Running Terraform deployment"
terraform init
#terraform plan -var "subscriptionid_hub=$subscription" -var "subscriptionid_spoke=$subscription_spoke"

terraform apply -var subscriptionid_hub=$subscription -var subscriptionid_spoke=$subscription_spoke -auto-approve