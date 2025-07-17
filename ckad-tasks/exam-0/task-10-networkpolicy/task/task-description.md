# Advanced Networking Task: NetworkPolicy

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to restrict network access using a NetworkPolicy.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `frontend.yaml`, `backend.yaml`, `unrelated.yaml` – Deployment manifests

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
kubectl apply -f prep/frontend.yaml
kubectl apply -f prep/backend.yaml
kubectl apply -f prep/unrelated.yaml
```

Create the NetworkPolicy manifest as `answer/solution.yaml`.

## Requirements
- Create a namespace named `exam-0-task-10`.
- Deploy three Deployments: `frontend`, `backend`, and `unrelated` in that namespace, each with a single pod.
- Create a NetworkPolicy that allows only the `frontend` pod to connect to the `backend` pod on port 80. All other traffic should be denied.

## Deliverables
- NetworkPolicy manifest as `answer/solution.yaml`.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
kubectl apply -f prep/namespace.yaml
kubectl apply -f prep/frontend.yaml
kubectl apply -f prep/backend.yaml
kubectl apply -f prep/unrelated.yaml
kubectl apply -f answer/solution.yaml
# Test connectivity from frontend to backend (should succeed)
kubectl exec -n exam-0-task-10 $(kubectl get pod -l app=frontend -n exam-0-task-10 -o jsonpath='{.items[0].metadata.name}') -- wget -qO- http://backend:80
# Test connectivity from unrelated to backend (should be blocked)
kubectl exec -n exam-0-task-10 $(kubectl get pod -l app=unrelated -n exam-0-task-10 -o jsonpath='{.items[0].metadata.name}') -- wget -qO- http://backend:80
```
Expected result: Only the frontend pod can access the backend on port 80.
