# Multi-Container Pod (Sidecar Pattern)

**Points:** 7

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod using the sidecar pattern.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-08`.
- Create a Pod named `sidecar-demo` in that namespace with two containers:
  - `main-app`: writes a message to a shared volume.
  - `sidecar`: reads and prints the message from the shared volume.
- Use the `busybox` image for both containers.
- Use an `emptyDir` volume for sharing data between containers.
- The `main-app` container should write the message `Hello from main-app!` to the file `/shared/message` in the shared volume.
- The `sidecar` container should read and print the message from the file `/shared/message`.
- Both containers must mount the shared volume at `/shared`.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that demonstrates the sidecar pattern with data sharing.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The sidecar must read the message from the shared volume file, not from logs or other sources.
- The message must be written to and read from the exact file path `/shared/message`.
- Both containers must use the shared volume for communication.
