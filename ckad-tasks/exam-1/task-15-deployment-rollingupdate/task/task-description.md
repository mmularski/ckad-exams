# Deployment Rolling Update

**Points:** 5

## Scenario
You need to perform a rolling update of a Deployment and verify the update strategy.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `deployment.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-15`.
- Create a Deployment named `rolling-demo` in that namespace with 3 replicas of the `nginx:1.21` image.
- The Deployment must use the label `app: rolling-demo`.
- Set the rolling update strategy to allow max 1 unavailable pod and max 2 surge pods during update.
- Update the Deployment to use image `nginx:1.22` and perform a rolling update.
- The Deployment should remain available during the update.

## Deliverables
- `deployment.yaml` in the `prep/` directory (final version with `nginx:1.22`).
- A Deployment that uses the correct rolling update strategy.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```