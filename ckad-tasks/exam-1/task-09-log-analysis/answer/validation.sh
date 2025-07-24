#!/bin/bash
set -e

NAMESPACE=exam-1-task-09
POD_NAME=logger-demo
ERROR_FILE=prep/error.txt
EXPECTED="ERROR: Failed to connect to database"

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Check pod configuration
POD_IMAGE=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].image}')
POD_CONTAINER_NAME=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].name}')

if [ "$POD_IMAGE" != "busybox" ]; then
  echo "❌ [FAIL] Pod should use busybox image, got: $POD_IMAGE"
  exit 1
fi

if [ "$POD_CONTAINER_NAME" != "busybox" ]; then
  echo "❌ [FAIL] Pod container should be named 'busybox', got: $POD_CONTAINER_NAME"
  exit 1
fi

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

# Check error.txt exists and contains the error line
if [ ! -f "$ERROR_FILE" ]; then
  echo ""
  echo "❌ [FAIL] $ERROR_FILE not found."
  echo ""
  exit 1
fi

if grep -Fxq "$EXPECTED" "$ERROR_FILE"; then
  echo ""
  echo "✅ [PASS] Pod is correctly configured and error.txt contains the correct error line."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] error.txt does not contain the correct error line."
  echo ""
  exit 1
fi