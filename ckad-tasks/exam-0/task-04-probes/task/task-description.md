# Readiness and Liveness Probes

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to add readiness and liveness probes to a Pod.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:

```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-0-task-04`.
- Create a Pod named `probes-demo` in that namespace with a single container based on the `nginx:1.21` image.
- Add a liveness probe that checks HTTP GET `/` on port 80.
- Add a readiness probe that checks HTTP GET `/` on port 80.

## Deliverables
- `pod.yaml` in the `prep/` directory.
- A Pod with working readiness and liveness probes.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should remain in Running state.