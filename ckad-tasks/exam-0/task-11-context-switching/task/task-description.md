# Context Switching

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to manage resources across multiple namespaces.

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
- Create two namespaces: `ns-one` and `ns-two`.
- Create a Pod named `pod-one` in `ns-one` and a Pod named `pod-two` in `ns-two`.
- Demonstrate how to list pods in both namespaces and how to switch context between them.

## Deliverables
- All manifests in the `prep/` directory.
- A short guide in `answer/guide.md` explaining how to switch context and list resources.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
