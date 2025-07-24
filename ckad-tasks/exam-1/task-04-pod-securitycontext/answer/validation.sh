#!/bin/bash
set -e

NAMESPACE=exam-1-task-04
POD_NAME=secure-pod

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

# Check SecurityContext configuration
RUN_AS_USER=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].securityContext.runAsUser}')
READ_ONLY_FS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}')
ALLOW_PRIV_ESC=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].securityContext.allowPrivilegeEscalation}')
RUN_AS_NON_ROOT=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.securityContext.runAsNonRoot}')

if [ "$RUN_AS_USER" != "1000" ]; then
  echo "❌ [FAIL] Container should run as user 1000, got: $RUN_AS_USER"
  exit 1
fi

if [ "$READ_ONLY_FS" != "true" ]; then
  echo "❌ [FAIL] Container should have readOnlyRootFilesystem: true, got: $READ_ONLY_FS"
  exit 1
fi

if [ "$ALLOW_PRIV_ESC" != "false" ]; then
  echo "❌ [FAIL] Container should have allowPrivilegeEscalation: false, got: $ALLOW_PRIV_ESC"
  exit 1
fi

if [ "$RUN_AS_NON_ROOT" != "true" ]; then
  echo "❌ [FAIL] Pod should have runAsNonRoot: true, got: $RUN_AS_NON_ROOT"
  exit 1
fi

# Check pod logs for user id
LOG=$(kubectl logs "$POD_NAME" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "1000"; then
  echo ""
  echo "✅ [PASS] Pod has correct SecurityContext configuration and runs as non-root user."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Pod does not run as non-root user (uid 1000)."
  echo ""
  exit 1
fi