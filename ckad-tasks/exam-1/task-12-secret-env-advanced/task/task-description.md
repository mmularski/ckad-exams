# Secret as Environment Variable (Advanced)

**Points:** 7

## Scenario
You are working in a Kubernetes cluster. Your task is to use a Secret as an environment variable with base64 encoding.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-12`.
- Create a Secret named `advanced-secret` in that namespace with a key named `encoded-data` containing the base64-encoded value `SUCCESSFUL!`.
- Create a Pod named `secret-advanced-demo` that reads the Secret key `encoded-data` as an environment variable named `DECODED_MESSAGE`.
- The Pod should display the secret value (output: `SUCCESSFUL!`).

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
- Use environment variables to pass the Secret data to the container.
- The resource names, Secret content, and output must match the requirements above.