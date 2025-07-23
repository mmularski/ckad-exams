# Custom Image Requirement

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to deploy a Pod using a custom-built image.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

Build the Docker image:

```sh
docker build -t custom-image:latest prep/
# If using minikube:
minikube image load custom-image:latest
```

You must create `Dockerfile` and `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-13`.
- Build a Docker image named `custom-image:latest` that prints `Hello from custom image` on startup.
- Create a Pod named `custom-image-demo` in the namespace using this image.

## Deliverables
- `Dockerfile` and `pod.yaml` in the `prep/` directory.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```
