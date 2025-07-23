# Log Analysis and Debugging

**Points:** 5

## Scenario
You need to analyze pod logs to troubleshoot an application issue.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-09`.
- Create a Pod named `logger-demo` in that namespace using the `busybox` image.
- The container should print the following lines (in order) on startup, then sleep:
  - `INFO: Application started`
  - `ERROR: Failed to connect to database`
  - `INFO: Retrying...`
- Your task: Deploy the pod, then use `kubectl logs` to extract and document the error message in `prep/error.txt`.

## Deliverables
- `pod.yaml` and `error.txt` in the `prep/` directory.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```