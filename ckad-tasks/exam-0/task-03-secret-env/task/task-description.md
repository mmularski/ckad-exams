# Secret as Environment Variable

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to use a Secret as an environment variable in a Pod.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

You must create `secret.yaml` and `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-03`.
- Create a Secret named `env-secret` in that namespace with a key `SECRET_MESSAGE` and value `TopSecretValue` (base64 encoded).
- Create a Pod named `secret-env-demo` in the same namespace.
- The Pod should have a single container based on the `busybox` image.
- The container should read the value of `SECRET_MESSAGE` from the Secret as an environment variable and print it on startup.

## Deliverables
- `secret.yaml` and `pod.yaml` in the `prep/` directory.
- A Pod that prints the value of `SECRET_MESSAGE` from the Secret on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should remain in Running state (e.g., use `sleep`).