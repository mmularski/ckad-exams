#!/bin/bash
set -e

NAMESPACE=exam-1-task-09
POD_NAME=broken-app

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for pod to be running
for i in {1..15}; do
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

# Check if application is running without errors
POD_LOGS=$(kubectl logs "$POD_NAME" -n "$NAMESPACE" 2>&1)

# Check if logs don't contain error messages
if ! echo "$POD_LOGS" | grep -q "error\|Error\|ERROR\|emerg\|unknown directive"; then
  echo ""
  echo "✅ [PASS] Application is running correctly without errors."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete configmap nginx-config -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Application is still generating errors."
  echo "📋 Pod logs:"
  kubectl logs "$POD_NAME" -n "$NAMESPACE"
  echo ""
  exit 1
fi