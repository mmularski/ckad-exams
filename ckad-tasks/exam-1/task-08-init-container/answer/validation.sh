#!/bin/bash
set -e

NAMESPACE=exam-1-task-08
POD_NAME=init-demo
EXPECTED_MSG="init ready"

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Check init container configuration
INIT_CONTAINER_NAME=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.initContainers[0].name}')
INIT_IMAGE=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.initContainers[0].image}')
MAIN_CONTAINER_NAME=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].name}')
MAIN_IMAGE=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].image}')
VOLUME_TYPE=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.volumes[0].emptyDir}')

if [ "$INIT_CONTAINER_NAME" != "init" ]; then
  echo "❌ [FAIL] Init container should be named 'init', got: $INIT_CONTAINER_NAME"
  exit 1
fi

if [ "$INIT_IMAGE" != "busybox" ]; then
  echo "❌ [FAIL] Init container should use busybox image, got: $INIT_IMAGE"
  exit 1
fi

if [ "$MAIN_CONTAINER_NAME" != "main" ]; then
  echo "❌ [FAIL] Main container should be named 'main', got: $MAIN_CONTAINER_NAME"
  exit 1
fi

if [ "$MAIN_IMAGE" != "busybox" ]; then
  echo "❌ [FAIL] Main container should use busybox image, got: $MAIN_IMAGE"
  exit 1
fi

if [ -z "$VOLUME_TYPE" ]; then
  echo "❌ [FAIL] Pod should have emptyDir volume"
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

# Check pod logs for expected message
LOG=$(kubectl logs "$POD_NAME" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "$EXPECTED_MSG"; then
  echo ""
  echo "✅ [PASS] Init container is correctly configured and found expected message in pod logs."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
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