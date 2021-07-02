#!/bin/bash
rg="aks-sql"
context="aks-sql-cluster"

printf "\n\nRemoving resource Group with AKS and SQL Deployed: [%s]" $rg
az group delete -g $rg -y > /dev/null 2>&1

printf "\nRemoving kubectl context from config: [%s]" $context
kubectl config delete-context $context > /dev/null 2>&1

printf "\nDone."

