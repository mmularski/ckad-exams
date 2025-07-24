# Deployment Management and Scaling

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Deployment with multiple replicas and scale it.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-06`.
- Create a Deployment named `nginx-deployment` with the following configuration:
  - 3 replicas
  - Image: `nginx:1.21`
  - Pods must be labeled with `app: nginx-deployment`
- The Deployment should be ready and all pods should be running.

## Deliverables
- All required manifests in the `prep/` directory.
- A Deployment with 3 running nginx pods in the namespace.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
