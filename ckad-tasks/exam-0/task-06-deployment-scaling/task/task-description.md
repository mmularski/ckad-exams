# Deployment Management and Scaling

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create and scale a Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

You must create `deployment.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-06`.
- Create a Deployment named `nginx-deployment` in that namespace using the `nginx:1.21` image.
- The Deployment should have 3 replicas.
- The Deployment should expose port 80.

## Deliverables
- `deployment.yaml` in the `prep/` directory.
- A Deployment with 3 running nginx pods in the namespace.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
kubectl apply -f prep/namespace.yaml
kubectl apply -f prep/deployment.yaml
kubectl get deployment nginx-deployment -n exam-0-task-06
kubectl get pods -n exam-0-task-06
```
Expected result: The Deployment has 3 pods in Running state.

## Notes
- You can use `kubectl scale deployment nginx-deployment --replicas=3 -n exam-0-task-06` to scale if needed.
