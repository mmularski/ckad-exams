# NetworkPolicy: Namespace Isolation

**Points:** 5

## Scenario
You need to restrict network access so that only pods from a specific namespace can access a backend pod.

## Preparation
In the `prep/` directory you will find:
- `namespace-a.yaml`, `namespace-b.yaml` – namespace manifests

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace-a.yaml
kubectl apply -f prep/namespace-b.yaml
```

You must create `pod-a.yaml`, `pod-b.yaml` and `networkpolicy.yaml` yourself as part of the solution.

## Requirements
- Create two namespaces: `ns-a` and `ns-b`.
- In `ns-a`, create a Pod named `backend` (busybox, sleep).
- In `ns-b`, create a Pod named `client` (busybox, sleep).
- Create a NetworkPolicy in `ns-a` that allows only pods from `ns-b` to connect to `backend` on port 80 (TCP).
- All other traffic to `backend` should be denied.

## Deliverables
- `pod-a.yaml`, `pod-b.yaml`, `networkpolicy.yaml` in the `prep/` directory.
- A NetworkPolicy that enforces namespace-based isolation.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```