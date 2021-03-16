# k8sdashboard-oauth2

Prerequisites

A Kubernetes cluster with two web services running with an Nginx ingress and Let’s Encrypt. This tutorial builds on How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes. Be sure to follow it to the very end in order to complete this tutorial.
A GitHub account.

## Step 1: Creating the GitHub Token
Create a GitHub OAuth 2 Proxy token either via your org’s GitHub setting page or your https://github.com/settings/applications/new .

## Step 2: Enter the URL
Enter your service a SSL URL as well as a “callback URL” at  the /oauth2 path. For example: https://yourapp.example.com then https://yourapp.example.com/oauth2/callback


## install Cert-manager + ouath2-proxy + kubernetes dashboard.

Run the install install.sh script with 4 arguments.

1) FQDN for dashboard
2) Client ID
3) Client Secret
4) Cookie Secret

You can create the cookie secret with this little docker invocation:
```sh
docker run -ti --rm python:3-alpine \
    python -c 'import secrets,base64; print(base64.b64encode(base64.b64encode(secrets.token_bytes(16))));'
```
./install.sh "Hostname" "ClientID" "ClientSecret" "CookieSecret"

The script will install cert-manager with selfsiged issuer and kubernetes dashboard with Oauth2-proxy
