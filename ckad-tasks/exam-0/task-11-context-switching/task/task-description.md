# Context Switching

**Points:** 5

## Scenario
You are working in a Kubernetes cluster with multiple namespaces. Your task is to learn how to switch between different namespaces and manage resources without constantly specifying the `-n` flag.

## Preparation
In the `prep/` directory you will find:
- `namespace1.yaml`, `namespace2.yaml` – namespace manifests
- `pod1.yaml`, `pod2.yaml` – pod manifests

**Note:** These manifests are provided for you to practice context switching.

## Requirements
- Two namespaces are created: `exam-0-task-11-1` and `exam-0-task-11-2`.
- A Pod named `pod-one` is created in `exam-0-task-11-1` and a Pod named `pod-two` is created in `exam-0-task-11-2`.
- Learn how to switch context between namespaces so you can list pods without using the `-n` flag.

## What You Should Practice
After the environment is set up, try these commands to understand context switching:

```sh
# List pods in specific namespaces (with -n flag)
kubectl get pods -n exam-0-task-11-1
kubectl get pods -n exam-0-task-11-2

# Switch context to exam-0-task-11-1
kubectl config set-context --current --namespace=exam-0-task-11-1
kubectl get pods  # Now lists pods from exam-0-task-11-1 without -n

# Switch context to exam-0-task-11-2
kubectl config set-context --current --namespace=exam-0-task-11-2
kubectl get pods  # Now lists pods from exam-0-task-11-2 without -n

# Return to default namespace
kubectl config set-context --current --namespace=default
```

## Deliverables
- Practice the context switching commands above to understand how they work.
- Pass the validation described below.

## Validation
To validate your understanding, run:

```sh
./answer/validation.sh
```

## Cleanup
When you're done practicing, clean up the resources:

```sh
kubectl delete namespace exam-0-task-11-1
kubectl delete namespace exam-0-task-11-2
```
