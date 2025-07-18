# Secret as Environment Variable (Advanced)

**Points:** 5

## Scenario
You need to use a Secret as an environment variable in a Pod, but the secret value should be base64-encoded and then decoded by the container.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `secret.yaml` and `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-12`.
- Create a Secret named `encoded-secret` in that namespace with a key `ENCODED_MSG` and value `U1VDQ0VTU0ZVTCE=` (which is base64 for `SUCCESSFUL!`).
- Create a Pod named `secret-advanced-demo` in the namespace.
- The Pod should use the `busybox` image and read the value of `ENCODED_MSG` as an environment variable, decode it from base64, print the decoded value, then sleep.

## Deliverables
- `secret.yaml` and `pod.yaml` in the `prep/` directory.
- A Pod that prints the decoded secret value on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```