# Advanced Networking Task: NetworkPolicy

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to restrict network access using a NetworkPolicy.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `frontend.yaml`, `backend.yaml`, `unrelated.yaml` – Deployment manifests

**Important:** NetworkPolicy requires a CNI (Container Network Interface) that supports NetworkPolicy. If you're using minikube, you need to start it with a compatible CNI:

```sh
# Stop existing minikube cluster
minikube stop

# Start minikube with calico CNI (supports NetworkPolicy)
minikube start --cni=calico --driver=docker

# Verify calico is running
kubectl get pods -n kube-system | grep calico
```

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
kubectl apply -f prep/frontend.yaml
kubectl apply -f prep/backend.yaml
kubectl apply -f prep/unrelated.yaml
```

Create the NetworkPolicy manifest as `prep/networkpolicy.yaml`.

## Requirements
- Create a namespace named `exam-0-task-10`.
- Deploy three Deployments: `frontend`, `backend`, and `unrelated` in that namespace, each with a single pod.
- Create a NetworkPolicy that allows only the `frontend` pod to connect to the `backend` pod on port 80. All other traffic should be denied.

## Deliverables
- NetworkPolicy manifest as `prep/networkpolicy.yaml`.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
