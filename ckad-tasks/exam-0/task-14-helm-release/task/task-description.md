# Helm Setup and PostgreSQL Installation

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to set up Helm and install a PostgreSQL database using Helm charts.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `values.yaml` – initial configuration values

**Note:** Use the provided files in the `prep/` directory to complete this task.

## Requirements
- Apply the namespace from `prep/namespace.yaml`.
- Add the Bitnami Helm repository `https://charts.bitnami.com/bitnami`.
- Install PostgreSQL using Helm with the configuration from `prep/values.yaml`.
- Use the release name `myapp`.
- Ensure the deployment is running and healthy.

## Deliverables
- A running PostgreSQL deployment installed via Helm with release name `myapp`.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- You need to add the Bitnami repository to Helm.
- You need to install the PostgreSQL chart using Helm with release name `myapp`.
- The `values.yaml` file contains the configuration for the PostgreSQL deployment.
