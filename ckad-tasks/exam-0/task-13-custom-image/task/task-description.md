# Custom Image Requirement

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to deploy a Pod using a custom-built image.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create additional files from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-13`.
- Build a Docker image named `custom-image:latest` using `busybox` as the base image.
- The Docker image should create a file `/app/message.txt` with the content `Hello from custom image`.
- Create a Pod named `custom-image-demo` in the namespace using this image.
- The Pod should read and display the content of the file when it starts.

## Deliverables
- `Dockerfile` and `pod.yaml` in the `prep/` directory.
- The Docker image should create the file `/app/message.txt` with the specified content.
- The Pod should read and display the file content on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
