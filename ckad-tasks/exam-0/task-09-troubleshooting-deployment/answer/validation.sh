#!/bin/bash
set -e

NAMESPACE=exam-0-task-09
DEPLOYMENT=answer/solution.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=broken-deployment
EXPECTED_IMAGE=nginx:1.21

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check pod is running
POD=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o jsonpath='{.items[0].metadata.name}')
STATUS=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.status.phase}')
if [ "$STATUS" != "Running" ]; then
  echo "[FAIL] Pod is not running (status: $STATUS)"
  exit 1
fi

# Check image
IMAGE=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].image}')
if [ "$IMAGE" == "$EXPECTED_IMAGE" ]; then
  echo "[PASS] Pod uses image $EXPECTED_IMAGE."
  exit 0
else
  echo "[FAIL] Pod does not use image $EXPECTED_IMAGE."
  exit 1
fi