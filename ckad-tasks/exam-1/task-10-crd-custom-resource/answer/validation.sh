#!/bin/bash
set -e

NAMESPACE=exam-1-task-10
CRD=prep/crd.yaml
CR=prep/custom-resource.yaml
NS_MANIFEST=prep/namespace.yaml
CRD_NAME=messages.exam.local
CR_NAME=hello-msg

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$CRD"
kubectl wait --for=condition=Established crd/$CRD_NAME --timeout=30s
kubectl apply -f "$CR"

# Check CRD exists
kubectl get crd $CRD_NAME

# Check custom resource exists
kubectl get message $CR_NAME -n $NAMESPACE

# Check spec.text field
TEXT=$(kubectl get message $CR_NAME -n $NAMESPACE -o jsonpath='{.spec.text}')
if [ "$TEXT" == "Hello CRD!" ]; then
  echo "[PASS] Custom resource created and has correct text."
  exit 0
else
  echo "[FAIL] Custom resource text is incorrect."
  exit 1
fi