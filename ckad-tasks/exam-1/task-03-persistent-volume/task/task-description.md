# PersistentVolume and PersistentVolumeClaim

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create persistent storage using PersistentVolume and PersistentVolumeClaim.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-03`.
- Create a PersistentVolume named `exam1-pv` with the following specifications:
  - Storage capacity: `1Gi`
  - Access mode: `ReadWriteOnce`
  - Storage backend: `hostPath` with path `/tmp/exam1-pv`
- Create a PersistentVolumeClaim named `exam1-pvc` with the following specifications:
  - Storage capacity: `1Gi`
  - Access mode: `ReadWriteOnce`
- Create a Pod that uses the persistent storage to write data.
- The Pod should write data to the persistent volume and remain running.

## Deliverables
- All required manifests in the `prep/` directory.
- A Pod that writes data to persistent storage.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use hostPath as the storage backend for the PersistentVolume.
- The Pod should write data to the persistent volume and remain in Running state.
- The PersistentVolume and PersistentVolumeClaim must have the exact names and specifications listed above.