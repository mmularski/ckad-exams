# ResourceQuota and LimitRange

**Points:** 7

## Scenario
You are working in a Kubernetes cluster. Your task is to enforce resource usage limits using ResourceQuota and LimitRange.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-05`.
- Create a ResourceQuota named `compute-quota` with the following limits:
  - `requests.cpu`: `500m`
  - `requests.memory`: `256Mi`
  - `limits.cpu`: `500m`
  - `limits.memory`: `256Mi`
- Create a LimitRange named `default-limits` with the following defaults:
  - Default CPU limit: `200m`
  - Default memory limit: `128Mi`
  - Default CPU request: `100m`
  - Default memory request: `64Mi`
- Create a Pod named `quota-demo` that uses the default resource settings.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that runs with default resource requests and limits.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The ResourceQuota should limit total CPU and memory usage.
- The LimitRange should set default resource requests and limits for containers.
- The Pod should start successfully with the default resource settings.
- The ResourceQuota and LimitRange must have the exact names and specifications listed above.