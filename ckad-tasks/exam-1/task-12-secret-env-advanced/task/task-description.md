# Secret as Environment Variable (Advanced)

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to use a Secret as an environment variable with base64 encoding.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-12`.
- Create a Secret named `advanced-secret` in that namespace with base64-encoded data containing the value `SUCCESSFUL!`.
- Create a Pod named `secret-advanced-demo` that reads the Secret as an environment variable and decodes it.
- The Pod should display the decoded secret value (output: `SUCCESSFUL!`).

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that prints the decoded secret value on startup.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Secret should contain base64-encoded data.
- The Pod should decode the data and display the result.
- Use environment variables to pass the Secret data to the container.
- The resource names, Secret content, and output must match the requirements above.