# Troubleshooting Deployment

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to troubleshoot and fix a broken Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `broken-deployment.yaml` – broken Deployment manifest

**Note:** You need to identify and fix the issues in the broken deployment. Create a corrected version as `deployment-fixed.yaml` - do not modify the original broken file.

## Requirements
- Create a namespace named `exam-0-task-09`.
- Deploy a Deployment named `broken-deployment` in that namespace. The Deployment is intentionally broken.
- Identify and fix the issue so that the Deployment becomes healthy and the pod is running.

## Deliverables
- Corrected Deployment manifest as `prep/deployment-fixed.yaml`.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
