# CustomResourceDefinition (CRD)

**Points:** 8

## Scenario
You are working in a Kubernetes cluster. Your task is to define and use a custom resource.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-10`.
- Define a CustomResourceDefinition with the following specifications:
  - Group: `exam.local`
  - Kind: `Message`
  - Plural: `messages`
  - Singular: `message`
  - Scope: `Namespaced`
  - Schema: should include a `text` field of type `string` in the spec section
- Create a custom resource instance named `hello-msg` with `text` field set to `"Hello CRD!"` in the spec section
- The CRD and resource should be properly configured.

## Deliverables
- All required manifests in the `prep/` directory.
- A CRD and custom resource as described.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Define a CRD with group `exam.local` and kind `Message`.
- Create a custom resource with a `text` field.
- The resource should be namespaced.
- The CRD and custom resource must have the exact specifications listed above.