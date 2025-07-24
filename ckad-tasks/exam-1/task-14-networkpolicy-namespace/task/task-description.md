# NetworkPolicy with Namespace Selector

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a NetworkPolicy that controls traffic between namespaces.

## Preparation
In the `prep/` directory you will find:
- `namespace-a.yaml`, `namespace-b.yaml` – namespace manifests

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create two namespaces: `ns-a` and `ns-b`.
- Create a Pod named `backend` in namespace `ns-a`.
- Create a Pod named `client` in namespace `ns-b`.
- Create a NetworkPolicy named `allow-from-ns-b` in namespace `ns-a` that allows traffic from namespace `ns-b` to the `backend` pod.
- The NetworkPolicy should use namespace selectors.

## Deliverables
- All required manifests in the `prep/` directory.
- A NetworkPolicy that controls traffic between namespaces.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- Use namespace selectors in the NetworkPolicy.
- The policy should allow traffic from one namespace to specific pods in another namespace.
- Test connectivity to verify the policy works correctly.
- The resource names must match the requirements above.