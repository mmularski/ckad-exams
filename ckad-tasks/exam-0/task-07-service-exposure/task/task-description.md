# Service Exposure

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to expose a Deployment using a Service.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

You must create `deployment.yaml` and `service.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-07`.
- Create a Deployment named `web-deployment` in that namespace using the `nginx:1.21` image with 2 replicas.
- Create a Service named `web-service` that exposes the Deployment on port 80.
- Use label `app: web-deployment` for pod selector and template labels.

## Deliverables
- `deployment.yaml` and `service.yaml` in the `prep/` directory.
- A Service that exposes the Deployment on port 80.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- You can use `kubectl port-forward` to access the Service if needed.
