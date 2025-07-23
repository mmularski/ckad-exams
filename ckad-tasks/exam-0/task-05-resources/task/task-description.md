# Resource Requests and Limits

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to set resource requests and limits for a Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-05`.
- Create a Deployment named `resources-demo` in that namespace.
- The Deployment should have 2 replicas.
- Use the `nginx:1.21` image.
- Set resource requests: 100m CPU and 64Mi memory.
- Set resource limits: 200m CPU and 128Mi memory.
- Use the label `app: web-server`.

## Deliverables
- All required manifests in the `prep/` directory.
- A Deployment with proper resource requests and limits configured.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Resource requests and limits should be properly configured for both CPU and memory.