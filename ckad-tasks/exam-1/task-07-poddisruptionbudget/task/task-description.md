# PodDisruptionBudget

**Points:** 6

## Scenario
You are working in a Kubernetes cluster. Your task is to ensure high availability using a PodDisruptionBudget.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-07`.
- Create a Deployment named `ha-app` with 3 replicas using nginx image and label `app=ha-app`.
- Create a PodDisruptionBudget named `ha-pdb` for the `ha-app` Deployment to ensure a minimum of 2 pods are always available during voluntary disruptions.

## Deliverables
- All required manifests in the `prep/` directory.
- A Deployment and PDB that enforce high availability.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use nginx image for the application.
- The PDB should require at least 2 pods to be available.
- The Deployment should have 3 replicas.
- The PDB must have the exact name and configuration listed above.