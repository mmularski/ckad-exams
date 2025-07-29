# Ingress Exposure

**Points:** 7

## Scenario
You are working in a Kubernetes cluster. Your task is to expose a web application using an Ingress resource.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

**Important:** Ingress requires an Ingress controller to be installed. If you're using minikube, you need to enable the Ingress addon:

```sh
# Enable Ingress addon in minikube
minikube addons enable ingress

# Verify Ingress controller is running
kubectl get pods -n ingress-nginx

# Wait for Ingress controller to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

## Requirements
- Create a namespace named `exam-1-task-06`.
- Create a Deployment named `web-deployment` with 2 replicas using nginx image and label `app=web`.
- Create a Service named `web-service` that exposes the deployment on port 80 using selector `app=web`.
- Create an Ingress named `web-ingress` with the following configuration:
  - Host: `web.exam.local`
  - Path: `/`
  - Path type: `Prefix`
  - Backend service: `web-service`
  - Backend port: `80`

## Deliverables
- All required manifests in the `prep/` directory.
- An Ingress that exposes the web application.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use nginx image for the web application.
- The Ingress should route traffic for a specific host.
- The Ingress must have the exact configuration listed above.