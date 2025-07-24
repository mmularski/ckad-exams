# Init Container

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod that uses an init container to prepare data.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-08`.
- Create a Pod that uses an init container to prepare data for the main container.
- The Pod should have the following configuration:
  - Init container named `init` using `busybox` image
  - Main container named `main` using `busybox` image
  - Shared `emptyDir` volume named `data`
- The init container should write data to a shared volume.
- The main container should read and display the data prepared by the init container.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that demonstrates the use of an init container.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use an `emptyDir` volume shared between containers.
- The init container should write data to the volume.
- The main container should read and display the data.
- The containers must have the exact names and images listed above.