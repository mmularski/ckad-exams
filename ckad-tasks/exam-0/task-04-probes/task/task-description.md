# Readiness and Liveness Probes

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to add readiness and liveness probes to a Pod.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-04`.
- Create a Pod named `probes-demo` in that namespace.
- The Pod should have a single container based on the `nginx:1.21` image.
- Add a liveness probe that checks HTTP GET on path `/` and port `80` every 10 seconds.
- Add a readiness probe that checks HTTP GET on path `/` and port `80` every 10 seconds.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod with both liveness and readiness probes configured.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The probes should check the nginx web server's health endpoint.