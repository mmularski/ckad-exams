#!/bin/bash
set -e

NAMESPACE=exam-0-task-09
DEPLOYMENT=prep/deployment.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=broken-deployment

kubectl apply -f "$NS_MANIFEST"

# Delete the old broken deployment if it exists
kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true

# Apply the corrected deployment
kubectl apply -f "$DEPLOYMENT"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check pod is running
POD=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o jsonpath='{.items[0].metadata.name}')
STATUS=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.status.phase}')
if [ "$STATUS" != "Running" ]; then
  echo ""
  echo "❌ [FAIL] Pod is not running (status: $STATUS)"
  echo ""
  exit 1
fi

# Check image is nginx (any version)
IMAGE=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].image}')
if [[ "$IMAGE" == nginx* ]]; then
  echo ""
  echo "✅ [PASS] Pod uses nginx image: $IMAGE"
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Pod does not use nginx image (found: $IMAGE)"
  echo ""
  exit 1
fi