# Deployment Management and Scaling

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create and scale a Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-06`.
- Create a Deployment named `nginx-deployment` in that namespace.
- Use the `nginx:1.21` image.
- The Deployment should have 3 replicas.
- The Deployment should expose port 80.
- The Deployment must use the label `app: nginx-deployment`.

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
- You can use `kubectl scale deployment nginx-deployment --replicas=3 -n exam-0-task-06` to scale if needed.
