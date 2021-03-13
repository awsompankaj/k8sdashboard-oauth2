# k8sdashboard-oauth2

Prerequisites

A Kubernetes cluster with two web services running with an Nginx ingress and Let’s Encrypt. This tutorial builds on How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes. Be sure to follow it to the very end in order to complete this tutorial.
A GitHub account.

## Step 1: Creating the GitHub Token
Create a GitHub OAuth 2 Proxy token either via your org’s GitHub setting page or your https://github.com/settings/applications/new .

## Step 2: Enter the URL
Enter your service a SSL URL as well as a “callback URL” at  the /oauth2 path. For example: https://yourapp.example.com then https://yourapp.example.com/oauth2/callback


## install oauth2-proxy

```sh
helm install authproxy \
    --namespace=<Namespace> \
    --set config.clientID=<Client ID> \
    --set config.clientSecret=<Client Secret> \
    --set config.cookieSecret=<CookieSecret> \
    --set extraArgs.provider=github \
    --set extraArgs.email-domain="*" \
    stable/oauth2-proxy 
```

You can create the cookie secret with this little docker invocation:
```sh
docker run -ti --rm python:3-alpine \
    python -c 'import secrets,base64; print(base64.b64encode(base64.b64encode(secrets.token_bytes(16))));'
```
## install dashboard

Clone the repo
git clone https://github.com/awsompankaj/k8sdashboard-oauth2
cd k8sdashboard-oauth2

```sh
helm install dashboard . -n <namespace>
```

edit ouath2-proxy.ing a net you dashboard host

and access the application using github auth



