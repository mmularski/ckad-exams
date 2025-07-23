# RBAC and ServiceAccount

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to configure RBAC so that a ServiceAccount has limited permissions.

## Preparation
In the `prep/` directory you will find empty template files that you need to complete:
- `namespace.yaml` – namespace manifest (empty template)
- `serviceaccount.yaml` – ServiceAccount manifest (empty template)
- `role.yaml` – Role manifest (empty template)
- `rolebinding.yaml` – RoleBinding manifest (empty template)

**Note:** All files in `prep/` are currently empty templates with TODO comments. You need to create the complete manifests from scratch.

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
