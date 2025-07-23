# Context Switching

**Points:** 5

## Scenario
You are working in a Kubernetes cluster with multiple namespaces. Your task is to learn how to switch between different namespaces and manage resources without constantly specifying the `-n` flag.

## Preparation
In the `prep/` directory you will find:
- `namespace1.yaml`, `namespace2.yaml` – namespace manifests
- `pod1.yaml`, `pod2.yaml` – pod manifests

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace1.yaml
kubectl apply -f prep/namespace2.yaml
kubectl apply -f prep/pod1.yaml
kubectl apply -f prep/pod2.yaml
```

## Requirements
- Create two namespaces: `exam-0-task-11-1` and `exam-0-task-11-2`.
- Create a Pod named `pod-one` in `exam-0-task-11-1` and a Pod named `pod-two` in `exam-0-task-11-2`.
- Learn how to switch context between namespaces so you can list pods without using the `-n` flag.

## What You Should Practice
After applying the manifests, try these commands to understand context switching:

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
- All manifests in the `prep/` directory.
- Practice the context switching commands above to understand how they work.

## Cleanup
When you're done practicing, clean up the resources:

```sh
kubectl delete namespace exam-0-task-11-1
kubectl delete namespace exam-0-task-11-2
```
