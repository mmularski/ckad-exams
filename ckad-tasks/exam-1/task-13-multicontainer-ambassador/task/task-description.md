# Multi-Container Pod (Ambassador Pattern)

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod with two containers where one container acts as an ambassador/proxy for the other.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-13`.
- Create a Pod named `ambassador-demo` with two containers:
  - Main container named `app` that makes requests to `localhost:8080`
  - Ambassador container named `proxy` that uses nginx to proxy traffic to external services
- The main container should use `wget` to make a request to `localhost:8080`
- The ambassador container should mount the `nginx-proxy-config` ConfigMap and proxy traffic to `example.com`
- The Pod should demonstrate successful communication through the ambassador.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that demonstrates the ambassador pattern with traffic proxying.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The main container communicates with the ambassador container on localhost.
- The ambassador container forwards traffic to external services.
- Use nginx in the ambassador container to proxy HTTP traffic.
- The Pod must have the exact name and container configuration listed above.