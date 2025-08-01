# Pod with ConfigMap

**Points:** 4

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod that consumes configuration data from a ConfigMap.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-01`.
- Create a ConfigMap named `example-config` in that namespace with a key `APP_MESSAGE` and value `Hello from ConfigMap!`.
- Create a Pod named `configmap-demo` in the same namespace.
- The Pod should have a single container based on the `busybox` image.
- The container should read the value of `APP_MESSAGE` from the ConfigMap as an environment variable and print it on startup.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that prints the value of `APP_MESSAGE` from the ConfigMap on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should remain in Running state (e.g., use `sleep`).
