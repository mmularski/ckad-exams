# Job: Batch Processing

**Points:** 5

## Scenario
You need to run a one-time batch job in Kubernetes that processes a data file and prints the result.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `job.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-01`.
- Create a Job named `data-processor` in that namespace.
- The Job should use the `busybox` image and run the command: `cat /data/input.txt | tr a-z A-Z`
- Mount a ConfigMap as a volume at `/data` with a key `input.txt` containing the text `hello exam-1`.
- The Job should print the uppercase version of the file and then exit.

## Deliverables
- `job.yaml` and `configmap.yaml` in the `prep/` directory.
- A Job that prints `HELLO EXAM-1` in its logs.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
kubectl logs job/data-processor -n exam-1-task-01
# Output should contain: HELLO EXAM-1
```