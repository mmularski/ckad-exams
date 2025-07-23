# Resource Requests and Limits

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to set resource requests and limits for a Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

You must create `deployment.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-05`.
- Create a Deployment named `resources-demo` in that namespace with 2 replicas using the `nginx:1.21` image.
- Set resource requests: `cpu: 100m`, `memory: 64Mi`.
- Set resource limits: `cpu: 200m`, `memory: 128Mi`.
- Use label `app: web-server` for pod selector and template labels.

## Deliverables
- `deployment.yaml` in the `prep/` directory.
- A Deployment with 2 running pods and correct resource settings.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Deployment should remain healthy and pods should be Running.