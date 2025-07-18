#!/bin/bash
set -e

NAMESPACE=exam-0-task-08
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
POD_NAME=sidecar-demo
SIDECAR_CONTAINER=sidecar
EXPECTED_MSG="Hello from main-app!"

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$POD"

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

# Check sidecar logs for expected message
LOG=$(kubectl logs "$POD_NAME" -c "$SIDECAR_CONTAINER" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "$EXPECTED_MSG"; then
  echo ""
  echo "✅ [PASS] Found expected message in sidecar logs."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Expected message not found in sidecar logs."
  echo "📋 Sidecar logs:"
  echo "$LOG"
  echo ""
  exit 1
fi