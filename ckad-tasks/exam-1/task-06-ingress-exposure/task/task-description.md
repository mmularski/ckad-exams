# Ingress Exposure

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to expose a web application using an Ingress resource.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-06`.
- Deploy a web application with multiple replicas.
- Expose the application with a Service.
- Create an Ingress named `web-ingress` with the following configuration:
  - Host: `web.exam.local`
  - Path: `/`
  - Path type: `Prefix`
  - Backend service: `web-service`
  - Backend port: `80`

## Deliverables
- All required manifests in the `prep/` directory.
- An Ingress that exposes the web application.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use nginx image for the web application.
- The Ingress should route traffic for a specific host.
- Assume the Ingress controller is already installed.
- The Ingress must have the exact configuration listed above.