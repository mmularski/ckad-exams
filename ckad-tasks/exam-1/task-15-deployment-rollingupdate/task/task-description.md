# Deployment Rolling Update

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to perform a rolling update of a Deployment.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-15`.
- Create a Deployment named `rolling-demo` with the following configuration:
  - 3 replicas
  - Image: `nginx:1.22`
  - Rolling update strategy:
    - `maxUnavailable`: `1`
    - `maxSurge`: `2`
- The Deployment should remain available during the update process.

## Deliverables
- All required manifests in the `prep/` directory.
- A Deployment that uses the correct rolling update strategy.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use nginx image for the Deployment.
- Set appropriate rolling update strategy parameters.
- The Deployment should remain available during updates.
- The deployment name, replicas, image, and strategy parameters must match the requirements above.