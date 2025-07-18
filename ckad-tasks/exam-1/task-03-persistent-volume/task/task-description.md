# PersistentVolume and PersistentVolumeClaim

**Points:** 5

## Scenario
You need to provide persistent storage for a Pod using a PersistentVolume and PersistentVolumeClaim.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pv.yaml`, `pvc.yaml` and `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-03`.
- Create a PersistentVolume named `exam1-pv` (hostPath, 1Gi, ReadWriteOnce).
- Create a PersistentVolumeClaim named `exam1-pvc` in the namespace (1Gi, ReadWriteOnce).
- Create a Pod named `pv-demo` in the namespace that mounts the PVC at `/data`.
- The Pod should use the `busybox` image and write the text `persistent test` to `/data/test.txt` on startup, then sleep.

## Deliverables
- `pv.yaml`, `pvc.yaml`, `pod.yaml` in the `prep/` directory.
- A Pod that writes to persistent storage.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```