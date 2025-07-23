# Multi-Container Pod (Sidecar Pattern)

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod using the sidecar pattern.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-08`.
- Create a Pod named `sidecar-demo` in that namespace with two containers:
  - `main-app`: writes a message to a shared volume.
  - `sidecar`: reads and prints the message from the shared volume.
- Use the `busybox` image for both containers.
- Use an `emptyDir` volume for sharing data between containers.
- The `main-app` container should write the message `Hello from main-app!` to the shared volume.
- The `sidecar` container should read and print this message.

## Deliverables
- `pod.yaml` in the `prep/` directory.
- A Pod that demonstrates the sidecar pattern with data sharing.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
