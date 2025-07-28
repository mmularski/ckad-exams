# Application Debugging and Fix

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to debug and fix a broken application that is generating error logs.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest
- `broken-app.yaml` – a Pod with configuration issues
- `nginx-config.yaml` – a ConfigMap with nginx configuration

**Note:** You need to analyze the logs and fix the application configuration.

## Requirements
- Create a namespace named `exam-1-task-09`.
- Apply the provided `broken-app.yaml` manifest.
- Analyze the application logs to identify the error.
- Fix the application configuration to resolve the error.
- Ensure the application runs without errors.

## Deliverables
- All required manifests in the `prep/` directory.
- A working application that no longer generates error logs.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The application should run successfully after the fix.