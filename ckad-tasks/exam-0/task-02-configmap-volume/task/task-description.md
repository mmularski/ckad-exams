# ConfigMap as Volume

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to mount a ConfigMap as a volume in a Pod.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-0-task-02`.
- Create a ConfigMap named `volume-config` in that namespace with a key `config.txt` and value `This is from ConfigMap volume!`.
- Create a Pod named `configmap-volume-demo` in the same namespace.
- The Pod should have a single container based on the `busybox` image.
- Mount the ConfigMap as a volume at `/etc/config` in the container.
- The container should print the contents of `/etc/config/config.txt` on startup and then sleep.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that prints the contents of the ConfigMap file on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should remain in Running state (e.g., use `sleep`).