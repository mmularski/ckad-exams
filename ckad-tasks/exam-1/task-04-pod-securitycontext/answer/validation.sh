#!/bin/bash
set -e

NAMESPACE=exam-1-task-04
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
POD_NAME=secure-pod

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$POD"

# Wait for pod to be running
for i in {1..10}; do
  STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$STATUS" == "Running" ]; then
    break
  fi
  sleep 2
done
if [ "$STATUS" != "Running" ]; then
  echo ""
  echo "❌ [FAIL] Pod $POD_NAME is not running (status: $STATUS)"
  echo ""
  exit 1
fi

# Check pod logs for user id
LOG=$(kubectl logs "$POD_NAME" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "1000"; then
  echo "✅ [PASS] Pod runs as non-root user."
else
  echo ""
  echo "❌ [FAIL] Pod does not run as non-root user."
  echo ""
  exit 1
fi

# Check securityContext
SC=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o json | grep readOnlyRootFilesystem)
if echo "$SC" | grep -q true; then
  echo ""
  echo "✅ [PASS] Pod has read-only root filesystem."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Pod does not have read-only root filesystem."
  echo ""
  exit 1
fi