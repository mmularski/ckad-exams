# RBAC and ServiceAccount

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to configure RBAC so that a ServiceAccount has limited permissions.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create additional manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-12`.
- Create a ServiceAccount named `limited-access` in that namespace.
- Configure RBAC so that the ServiceAccount can only read pod information but cannot create or delete pods.
- The ServiceAccount should only have permissions to perform `get` and `list` operations on pods.

## Deliverables
- All required manifests in the `prep/` directory.
- A ServiceAccount that can only perform `get` and `list` operations on pods in the namespace.
- The ServiceAccount should not have permissions to create or delete pods.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The ServiceAccount must be named `limited-access`.
- The ServiceAccount should only have permissions to read pods, not create or delete them.
