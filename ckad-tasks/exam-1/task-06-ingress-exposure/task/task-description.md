# Ingress Exposure

**Points:** 5

## Scenario
You need to expose a web application using an Ingress resource.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `deployment.yaml`, `service.yaml` and `ingress.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-06`.
- Deploy a Deployment named `web-deployment` with 2 replicas of the `nginx:1.21` image.
- Expose the Deployment with a Service named `web-service` on port 80.
- Create an Ingress named `web-ingress` that routes HTTP traffic for host `web.exam.local` to the Service on path `/`.
- Assume the Ingress controller is already installed.

## Deliverables
- `deployment.yaml`, `service.yaml`, `ingress.yaml` in the `prep/` directory.
- An Ingress that exposes the web application.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```