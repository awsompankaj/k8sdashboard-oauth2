#!/bin/bash

if [ "$#" -eq  "0" ] || [ "$#" -ne  "4" ]
   then
     echo "No arguments supplied or incorrect arguments"
     echo "usage: $0 hostname clientID clientsecret cookiesecret"
     exit 1
 fi

git clone https://github.com/awsompankaj/k8sdashboard-oauth2.git
cd k8sdashboard-oauth2


which helm
if [ $(echo $?) != 0 ]
then
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
fi


kubectl create ns cert-manager
kubectl create ns dashboard


##install cert-manager
cd cert-manager
helm install cert-manager . --namespace cert-manager  --create-namespace  --set installCRDs=true
kubectl create -f selfsigned.yaml
cd ../oauth2-proxy
## install authproxy
helm install authproxy . -n dashboard  --set config.clientID=$2 --set config.clientSecret=$3 --set config.cookieSecret=$4 --set extraArgs.provider=github  --set extraArgs.email-domain="*" --set ingress.enabled=true  --set ingress.path=/oauth2     --set ingress.hosts={$1}   --set ingress.tls[0].secretName=oauth-tls --set ingress.tls[1].hosts={$1} 


## install dashboard
cd ../dashboard

helm install dashboard . -n dashboard --set ingress.enabled=true  --set ingress.hosts={$1} --set ingress.tls[0].secretName=dashboard-tls --set ingress.tls[1].hosts={$1}

cd ../..
rm -rf k8sdashboard-oauth2 
