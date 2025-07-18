# Pod SecurityContext

**Points:** 5

## Scenario
You need to run a Pod with restricted privileges for security compliance.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-04`.
- Create a Pod named `secure-pod` in that namespace using the `busybox` image.
- The container must run as a non-root user (uid 1000), with the root filesystem mounted read-only.
- The container should not allow privilege escalation.
- The Pod should print its user id and then sleep.

## Deliverables
- `pod.yaml` in the `prep/` directory.
- A Pod that runs as a non-root user with a read-only root filesystem.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```