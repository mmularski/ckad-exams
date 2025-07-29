# Pod SecurityContext

**Points:** 6

## Scenario
You are working in a Kubernetes cluster. Your task is to create a Pod with restricted security settings.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-04`.
- Create a Pod named `secure-pod` that runs with restricted security settings.
- The Pod should run as a non-root user with a read-only root filesystem.
- The Pod should not allow privilege escalation.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that runs with restricted security settings.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The Pod should run as a non-root user (uid 1000).
- The root filesystem should be mounted read-only.
- Privilege escalation should be disabled.
- The Pod must have the exact name listed above.