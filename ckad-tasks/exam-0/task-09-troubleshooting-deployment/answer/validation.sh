#!/bin/bash
set -e

NAMESPACE=exam-0-task-09
DEPLOYMENT_NAME=broken-deployment

echo "Applying namespace..."
kubectl apply -f prep/namespace.yaml

# Delete the old broken deployment if it exists
kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true

# Apply the corrected deployment
if [ -f "prep/deployment-fixed.yaml" ]; then
  echo "Applying fixed deployment..."
  kubectl apply -f prep/deployment-fixed.yaml
else
  echo "❌ [FAIL] No deployment-fixed.yaml found. Create the corrected deployment as deployment-fixed.yaml"
  exit 1
fi

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check pod is running (find by deployment name)
POD=$(kubectl get pods -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}' --field-selector=status.phase=Running 2>/dev/null || echo "")
if [ -z "$POD" ]; then
  echo ""
  echo "❌ [FAIL] No running pod found for deployment $DEPLOYMENT_NAME"
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