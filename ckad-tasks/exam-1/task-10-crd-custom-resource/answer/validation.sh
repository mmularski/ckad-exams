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
  echo ""
  echo "✅ [PASS] Custom resource created and has correct text."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete message "$CR_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete crd "$CRD_NAME" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Custom resource text is incorrect."
  echo ""
  exit 1
fi