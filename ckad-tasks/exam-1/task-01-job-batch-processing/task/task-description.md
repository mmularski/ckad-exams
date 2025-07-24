# Job: Batch Processing

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Job that processes data and prints the result.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-01`.
- Create a ConfigMap named `data-input` in that namespace with the following content:
  - Key: `input.txt`
  - Value: `hello exam-1`
- Create a Job named `data-processor` that:
  - Uses the `busybox` image
  - Mounts the above ConfigMap as a volume at `/data`
  - Reads `/data/input.txt`, converts its content to uppercase, and prints the result
- The Job should print the processed result and then exit.

## Deliverables
- All required manifests in the `prep/` directory.
- A Job that prints the processed data in its logs.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Job should process the data and exit successfully.
- Use a ConfigMap to provide the input data.
- The output in the Job logs must be exactly: `HELLO EXAM-1`.
- The resource names and ConfigMap content must match the requirements above.