# Service Exposure

**Points:** 6

## Scenario
You are working in a Kubernetes cluster. Your task is to expose a Deployment using a Service.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-07`.
- Create a Deployment named `web-deployment` in that namespace.
- Use the `nginx:1.21` image with 2 replicas.
- Create a Service named `web-service` that exposes the Deployment on port 80.
- Use label `app: web-deployment` for pod selector and template labels.

## Deliverables
- All required manifests in the `prep/` directory.
- A Service that exposes the Deployment on port 80.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- You can use `kubectl port-forward` to access the Service if needed.
