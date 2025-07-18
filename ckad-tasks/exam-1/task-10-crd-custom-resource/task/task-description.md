# CustomResourceDefinition (CRD)

**Points:** 5

## Scenario
You need to define and use a simple custom resource in Kubernetes.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `crd.yaml` and `custom-resource.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-10`.
- Define a CRD named `messages.exam.local` with kind `Message`.
- Create a custom resource named `hello-msg` of kind `Message` in the namespace, with a spec field `text: "Hello CRD!"`.
- The CRD and resource should be cluster-scoped, but the resource should have a metadata.namespace set to `exam-1-task-10`.

## Deliverables
- `crd.yaml` and `custom-resource.yaml` in the `prep/` directory.
- A CRD and custom resource as described.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
./answer/validation.sh
```