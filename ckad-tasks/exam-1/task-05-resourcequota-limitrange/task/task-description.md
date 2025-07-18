# ResourceQuota and LimitRange

**Points:** 5

## Scenario
You need to enforce resource usage limits in a namespace using ResourceQuota and LimitRange.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `resourcequota.yaml`, `limitrange.yaml` and `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-05`.
- Create a ResourceQuota named `compute-quota` in the namespace that limits total CPU to 500m and memory to 256Mi.
- Create a LimitRange named `default-limits` in the namespace that sets default CPU request to 100m, limit to 200m, default memory request to 64Mi, limit to 128Mi.
- Create a Pod named `quota-demo` in the namespace using the `busybox` image (no explicit resources in pod spec).
- The Pod should start successfully and sleep.

## Deliverables
- `resourcequota.yaml`, `limitrange.yaml`, `pod.yaml` in the `prep/` directory.
- A Pod that runs with default resource requests/limits.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```