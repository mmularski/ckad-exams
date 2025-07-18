# PodDisruptionBudget

**Points:** 5

## Scenario
You need to ensure high availability of your application during voluntary disruptions using a PodDisruptionBudget.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `deployment.yaml` and `pdb.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-07`.
- Deploy a Deployment named `ha-app` with 3 replicas of the `nginx:1.21` image.
- Create a PodDisruptionBudget named `ha-pdb` that requires at least 2 pods to be available at all times.
- The PDB should select pods with label `app: ha-app`.

## Deliverables
- `deployment.yaml`, `pdb.yaml` in the `prep/` directory.
- A Deployment and PDB that enforce high availability.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```