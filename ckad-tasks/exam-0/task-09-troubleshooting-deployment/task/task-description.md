# Troubleshooting Deployment

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to troubleshoot and fix a broken Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `broken-deployment.yaml` – broken Deployment manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
kubectl apply -f prep/broken-deployment.yaml
```

Fix the manifest and save the corrected version as `prep/deployment.yaml`.

## Requirements
- Create a namespace named `exam-0-task-09`.
- Deploy a Deployment named `broken-deployment` in that namespace. The Deployment is intentionally broken (e.g., wrong image).
- The Deployment must use the label `app: broken-deployment`.
- Identify and fix the issue so that the Deployment becomes healthy and the pod is running.

## Deliverables
- Corrected Deployment manifest as `prep/deployment.yaml`.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
