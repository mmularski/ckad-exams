# ConfigMap as Volume (Advanced)

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to mount a ConfigMap as a volume with specific file selection.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-11`.
- Create a ConfigMap named `advanced-config` in that namespace with multiple data keys, including a key `setting` with value `advanced`.
- Create a Pod named `configmap-advanced-demo` that mounts only the `setting` key from the ConfigMap as a file using `subPath`.
- The Pod should read and display the mounted configuration data (output: `setting=advanced`).

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that mounts only the selected files from the ConfigMap.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use subPath to mount specific files from the ConfigMap.
- The Pod should read and display the configuration data.
- Only mount the required files, not all ConfigMap data.
- The resource names, ConfigMap content, and output must match the requirements above.