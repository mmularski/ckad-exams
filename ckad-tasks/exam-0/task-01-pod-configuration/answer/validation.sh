#!/bin/bash
set -e

NAMESPACE=exam-0-task-01
EXPECTED_MSG="Hello from ConfigMap!"
POD_NAME=configmap-demo

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for pod to be running
for i in {1..10}; do
  STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$STATUS" == "Running" ]; then
    break
  fi
  sleep 1
done
if [ "$STATUS" != "Running" ]; then
  echo ""
  echo "❌ [FAIL] Pod $POD_NAME is not running (status: $STATUS)"
  echo ""
  exit 1
fi

# Check pod logs for expected message
LOG=$(kubectl logs "$POD_NAME" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "$EXPECTED_MSG"; then
  echo ""
  echo "✅ [PASS] Found expected message in pod logs."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete configmap example-config -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Expected message not found in pod logs."
  echo "📋 Pod logs:"
  echo "$LOG"
  echo ""
  exit 1
fi
