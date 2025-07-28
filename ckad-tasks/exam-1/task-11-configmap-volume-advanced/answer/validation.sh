#!/bin/bash
set -e

NAMESPACE=exam-1-task-11
EXPECTED_MSG="setting=advanced"
POD_NAME=configmap-advanced-demo

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
  sleep 2
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

  # Check that only the 'setting' key is mounted, not other keys
  # The setting file should exist at /config/setting
  if kubectl exec "$POD_NAME" -n "$NAMESPACE" -- test -f /config/setting; then
    echo "✅ [PASS] Setting file is correctly mounted at /config/setting."
    echo ""
  else
    echo "❌ [FAIL] Setting file is not mounted correctly."
    echo ""
    exit 1
  fi

  # Check that other keys are not mounted
  if kubectl exec "$POD_NAME" -n "$NAMESPACE" -- test -f /config/debug 2>/dev/null; then
    echo "❌ [FAIL] Debug file should not be mounted."
    echo ""
    exit 1
  fi

  if kubectl exec "$POD_NAME" -n "$NAMESPACE" -- test -f /config/timeout 2>/dev/null; then
    echo "❌ [FAIL] Timeout file should not be mounted."
    echo ""
    exit 1
  fi

  if kubectl exec "$POD_NAME" -n "$NAMESPACE" -- test -f /config/internal 2>/dev/null; then
    echo "❌ [FAIL] Internal file should not be mounted."
    echo ""
    exit 1
  fi

  echo "✅ [PASS] Only the 'setting' key is mounted, other keys are correctly excluded."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete configmap advanced-config -n "$NAMESPACE" --ignore-not-found=true
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