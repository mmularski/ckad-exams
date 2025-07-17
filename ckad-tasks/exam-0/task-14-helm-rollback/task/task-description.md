# Helm Deployment and Rollback

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to deploy an application using Helm, simulate a failed upgrade, and perform a rollback.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `values-good.yaml`, `values-bad.yaml` – Helm values files

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

Make sure you have Helm installed and a chart available (e.g., nginx).

## Requirements
- Create a namespace named `exam-0-task-14`.
- Use a basic Helm chart (e.g., nginx) to deploy an application with `values-good.yaml`.
- Upgrade the release with `values-bad.yaml` to simulate a failure.
- Roll back to the previous working release.

## Deliverables
- All files in the `prep/` directory.
- A guide in `answer/guide.md` explaining the install, upgrade, and rollback steps.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
helm install myapp nginx --namespace exam-0-task-14 -f prep/values-good.yaml
helm upgrade myapp nginx --namespace exam-0-task-14 -f prep/values-bad.yaml || echo "Upgrade failed (expected)"
helm rollback myapp 1 --namespace exam-0-task-14
helm history myapp --namespace exam-0-task-14
kubectl get pods -n exam-0-task-14
```
Expected result: After rollback, the application works correctly and Helm history shows the rollback.
