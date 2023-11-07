#!/bin/bash
cd "$(dirname "$0")"

minikube delete; minikube start --memory='max'

helm repo add https://helm.elastic.co
helm repo add https://kubernetes.github.io/ingress-nginx
helm repo update
