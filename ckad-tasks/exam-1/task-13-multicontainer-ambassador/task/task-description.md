# Multi-Container Pod (Ambassador Pattern)

**Points:** 5

## Scenario
You need to create a Pod that uses the ambassador pattern to proxy traffic from the main application to an external service.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `pod.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-13`.
- Create a Pod named `ambassador-demo` in that namespace with two containers:
  - `app`: busybox, sends HTTP request to `localhost:8080` and prints the response, then sleeps.
  - `ambassador`: busybox, runs `socat TCP-LISTEN:8080,fork TCP:example.com:80` to proxy traffic to example.com.
- The main container should print the HTTP response from example.com (should start with `HTTP/1.1 200 OK`).

## Deliverables
- `pod.yaml` in the `prep/` directory.
- A Pod that demonstrates the ambassador pattern.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```