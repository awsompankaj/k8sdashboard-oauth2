#!/bin/bash

if [ "$#" -eq  "0" ] || [ "$#" -ne  "4" ]
   then
     echo "No arguments supplied or incorrect arguments"
     echo "usage: $0 hostname clientID clientsecret cookiesecret"
     exit 1
 fi

git clone https://github.com/awsompankaj/argocd-install.git
cd argocd-install

which helm
if [ $(echo $?) != 0 ]
then
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
fi


kubectl create ns cert-manager
kubectl create ns dashboard

helm install argocd . -n argocd  --set server.extraArgs={--insecure} --set server.ingress.enabled=true --set server.ingress.hosts={$3} 
PASS=$(kubectl get pods -n argocd  -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
sleep 30
argocd login $3 --username admin  --password $PASS --grpc-web  --insecure
argocd account update-password --account developer --current-password $PASS --new-password $2
argocd account update-password  --account admin --current-password $PASS --new-password $1
argocd logout $3
argocd login $3 --username developer  --password $2 --grpc-web  --insecure
argocd cluster add --in-cluster kubernetes-admin@kubernetes

cd ..
rm -rf argocd-install
