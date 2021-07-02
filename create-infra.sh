#!/bin/bash
loc="AustraliaEast"
rg="aks-sql"
cluster="aks-sql-cluster"
sqlSaPassword="MyC0m9l&xP@ssw0rd"

printf "\n-- Creating/checking resource group [%s]" $rg
az group create -n $rg -l $loc > /dev/null 2>&1

printf "\n-- Creating/checking cluster [%s]" $cluster
az aks show -g $rg -n $cluster > /dev/null 2>&1 || az aks create -g $rg -n $cluster --node-count 3 > /dev/null 2>&1

printf "\n-- Getting/Merging credentials"
az aks get-credentials -g $rg -n $cluster

printf "\n-- Setting up SQL secrets and storage/persistent volume"
alias k=kubectl
kubectl config set-context "aks-sql-cluster"
kubectl create secret generic mssql --from-literal=SA_PASSWORD=$sqlSaPassword > /dev/null 2>&1 || printf "...Skipping secret creation"

printf "\nCreating storage/persistent volume"
kubectl apply -f ./storage.yaml

printf "\nCreating SQL Pods/Services"
kubectl apply -f ./sqldeployment.yaml

printf "\nDone. Showing services - wait for public IP to be provisioned.\n"
kubectl get services mssql-deployment


