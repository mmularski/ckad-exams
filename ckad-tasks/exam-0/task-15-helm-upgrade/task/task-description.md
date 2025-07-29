# Helm Chart Upgrade

**Points:** 7

## Scenario
You are working in a Kubernetes cluster. Your task is to upgrade an existing PostgreSQL deployment using Helm with new configuration values.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `values-old.yaml` – current configuration values (for reference)

**Note:** You need to create the `values-upgrade.yaml` file in the `prep/` directory.

## Requirements
- Apply the namespace from `prep/namespace.yaml`.
- Ensure Task 14 is completed (PostgreSQL deployment must be running).
- Create a `values-upgrade.yaml` file in the `prep/` directory with the following new configuration:
  - CPU request: `200m` (increased by 100m)
  - Memory request: `384Mi` (increased by 128Mi)
- Perform a Helm upgrade to apply the new configuration using release name `myapp`.

## Deliverables
- The `values-upgrade.yaml` file in the `prep/` directory.
- A successfully upgraded PostgreSQL deployment with release name `myapp`.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- This task builds upon the PostgreSQL deployment from Task 14.