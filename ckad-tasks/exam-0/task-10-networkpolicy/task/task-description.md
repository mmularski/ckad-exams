# Advanced Networking Task: NetworkPolicy

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to restrict network access using a NetworkPolicy.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `frontend.yaml`, `backend.yaml`, `unrelated.yaml` – Deployment manifests

**Note:** You need to create additional manifests from scratch in the `prep/` directory.

**Important:** NetworkPolicy requires a CNI (Container Network Interface) that supports NetworkPolicy. If you're using minikube, you need to start it with a compatible CNI:

```sh
# Stop existing minikube cluster
minikube stop

# Start minikube with calico CNI (supports NetworkPolicy)
minikube start --cni=calico --driver=docker

# Verify calico is running
kubectl get pods -n kube-system | grep calico
```

## Requirements
- Create a namespace named `exam-0-task-10`.
- Deploy three Deployments: `frontend`, `backend`, and `unrelated` in that namespace, each with a single pod.
- Create a NetworkPolicy that allows only the `frontend` pod to connect to the `backend` pod on port 80. All other traffic should be denied.
- The frontend pod communicates with the backend using CoreDNS at `backend-api.exam-0-task-10.svc.cluster.local:80`.

## Deliverables
- All required manifests in the `prep/` directory.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
