#!/bin/bash
cd "$(dirname "$0")"

helm upgrade ingress ingress-nginx/ingress-nginx \
  --install \
  -n ingress --create-namespace

kubectl create namespace elastic-system --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f eck-license.yaml


helm upgrade elastic-operator elastic/eck-operator \
  --install \
  -n elastic-system

helm upgrade test es \
  --install \
  -n elastic --create-namespace