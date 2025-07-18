# Init Container

**Points:** 5

## Scenario
You need to use an init container to prepare data for the main application container.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-08`.
- Create a Pod named `init-demo` in that namespace.
- The Pod should have:
  - An init container that writes the text `init ready` to `/data/status.txt`.
  - A main container (busybox) that reads and prints the contents of `/data/status.txt` and then sleeps.
- Use an `emptyDir` volume mounted at `/data` in both containers.

## Deliverables
- `pod.yaml` in the `prep/` directory.
- A Pod that demonstrates the use of an init container.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```