# ConfigMap as Volume (Advanced)

**Points:** 5

## Scenario
You need to mount a ConfigMap as a volume and use a subPath to mount a single file from the ConfigMap.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `configmap.yaml` and `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-11`.
- Create a ConfigMap named `advanced-config` in that namespace with two keys: `app.conf` (value: `setting=advanced`) and `unused.txt` (value: `should-not-be-mounted`).
- Create a Pod named `configmap-advanced-demo` in the namespace.
- The Pod should use the `busybox` image and mount only the `app.conf` key from the ConfigMap as `/etc/app/app.conf` using subPath.
- The container should print the contents of `/etc/app/app.conf` on startup and then sleep.

## Deliverables
- `configmap.yaml` and `pod.yaml` in the `prep/` directory.
- A Pod that mounts only the selected file from the ConfigMap.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```