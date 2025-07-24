# Log Analysis and Debugging

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to analyze pod logs to troubleshoot an application issue.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-09`.
- Create a Pod named `logger-demo` with the following configuration:
  - Container named `busybox` using `busybox` image
  - Command that generates logs with different severity levels
- Analyze the logs to identify and document error messages.
- Create a file with the extracted error information.

## Deliverables
- All required manifests in the `prep/` directory.
- A file containing the extracted error information.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should generate logs with INFO and ERROR levels.
- Use `kubectl logs` to extract error messages.
- Document the error in a file in the prep directory.
- The Pod must have the exact name and container configuration listed above.