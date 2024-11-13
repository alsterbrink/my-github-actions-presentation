#!/bin/bash

# This script deletes the resource group and Azure AD App registration created by the Bicep template and script.
# Usage: ./delete_resources.sh <subscription-id> <resource-group-name> <app-name>

# Check if the correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <subscription-id> <resource-group-name> <app-name>"
    exit 1
fi

# Parameters
subscriptionId=$1
resourceGroupName=$2
appName=$3

# Delete the resource group
echo "Deleting resource group..."
for i in {1..5}; do
  az group delete --name $resourceGroupName --subscription $subscriptionId --yes --no-wait
  if [ $? -eq 0 ]; then
    echo "Resource group deletion initiated successfully."
    break
  else
    echo "Failed to initiate resource group deletion. Retrying in 10 seconds..."
    sleep 10
  fi
done




# Get the Object ID of the Azure AD App registration
id=$(az ad app list --display-name $appName --query "[0].id" --output tsv)

# Check if the app registration exists
if [ -z "$id" ]; then
    echo "Azure AD App registration not found."
else
    # Delete the Azure AD App registration
    echo "Deleting Azure AD App registration..."
    az ad app delete --id $id
fi

echo "Deletion process completed."