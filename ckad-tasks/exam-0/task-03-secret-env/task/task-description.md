# Secret as Environment Variable

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to use a Secret as an environment variable in a Pod.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-03`.
- Create a Secret named `app-secret` in that namespace with a key `DB_PASSWORD` and value `mysecretpassword`.
- Create a Pod named `secret-demo` in the same namespace.
- The Pod should have a single container based on the `busybox` image.
- The container should read the value of `DB_PASSWORD` from the Secret as an environment variable and print it on startup.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that prints the value of `DB_PASSWORD` from the Secret on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should remain in Running state (e.g., use `sleep`).