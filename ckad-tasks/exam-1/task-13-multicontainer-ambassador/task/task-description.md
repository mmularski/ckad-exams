# Multi-Container Pod (Ambassador Pattern)

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod that uses the ambassador pattern.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-13`.
- Create a Pod named `ambassador-demo` with two containers using the ambassador pattern:
  - Main container named `app` that communicates with an external service
  - Ambassador container that proxies traffic to example.com
- The main container should communicate with an external service through the ambassador container.
- The Pod should demonstrate successful communication and return HTTP 200 response.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that demonstrates the ambassador pattern.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use the ambassador pattern to proxy traffic to an external service.
- The main container should communicate through the ambassador container.
- The ambassador container should proxy traffic to example.com.
- The Pod must have the exact name and container configuration listed above.