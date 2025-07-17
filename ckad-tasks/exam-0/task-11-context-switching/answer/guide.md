# Context Switching Guide

To list pods in a specific namespace:

```
kubectl get pods -n ns-one
kubectl get pods -n ns-two
```

To switch context (if using named contexts):

```
kubectl config set-context --current --namespace=ns-one
kubectl get pods
kubectl config set-context --current --namespace=ns-two
kubectl get pods
```

To return to the default namespace:

```
kubectl config set-context --current --namespace=default
```
