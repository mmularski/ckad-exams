# RBAC and ServiceAccount

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to configure RBAC so that a ServiceAccount has limited permissions.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `serviceaccount.yaml` – ServiceAccount manifest
- `role.yaml` – Role manifest
- `rolebinding.yaml` – RoleBinding manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
kubectl apply -f prep/serviceaccount.yaml
kubectl apply -f prep/role.yaml
kubectl apply -f prep/rolebinding.yaml
```

## Requirements
- Create a namespace named `exam-0-task-12`.
- Create a ServiceAccount named `limited-access` in that namespace.
- Create a Role named `pod-reader` that allows only `get` and `list` operations on pods in the namespace.
- Create a RoleBinding named `read-pods-binding` to bind the Role to the ServiceAccount.

## Deliverables
- All manifests in the `prep/` directory.
- A ServiceAccount with read-only access to pods in the namespace.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
