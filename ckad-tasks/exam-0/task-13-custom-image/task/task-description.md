# Custom Image Requirement

**Points:** 7

## Scenario
You are working in a Kubernetes cluster. Your task is to deploy a Pod using a custom-built image.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create additional files from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-13`.
- Build a container image named `custom-image:latest` using `busybox` as the base image.
- You can use either Docker or Podman to build the image.
- The container image should create a file `/app/message.txt` with the content `Hello from custom image`.
- Create a Pod named `custom-image-demo` in the namespace using this image.
- The Pod should read and display the content of the file when it starts.

## Deliverables
- `Dockerfile` and `pod.yaml` in the `prep/` directory.
- The container image should create the file `/app/message.txt` with the specified content.
- The Pod should read and display the file content on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
