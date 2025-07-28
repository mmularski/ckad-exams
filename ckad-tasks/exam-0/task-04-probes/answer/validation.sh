#!/bin/bash
set -e

NAMESPACE=exam-0-task-04
POD_NAME=probes-demo

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

# Check for readiness and liveness probes in the manifest
READINESS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o json | grep readinessProbe)
LIVENESS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o json | grep livenessProbe)

if [ -z "$READINESS" ] || [ -z "$LIVENESS" ]; then
  echo ""
  echo "❌ [FAIL] Readiness and/or liveness probe is missing."
  echo ""
  exit 1
fi

# Check specific probe configuration values
echo "Checking probe configuration..."

# Check readiness probe periodSeconds
READINESS_PERIOD=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].readinessProbe.periodSeconds}')
if [ "$READINESS_PERIOD" != "10" ]; then
  echo "❌ [FAIL] Readiness probe periodSeconds should be 10, got: $READINESS_PERIOD"
  exit 1
fi

# Check liveness probe periodSeconds
LIVENESS_PERIOD=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].livenessProbe.periodSeconds}')
if [ "$LIVENESS_PERIOD" != "10" ]; then
  echo "❌ [FAIL] Liveness probe periodSeconds should be 10, got: $LIVENESS_PERIOD"
  exit 1
fi

# Check readiness probe path and port
READINESS_PATH=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.path}')
READINESS_PORT=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].readinessProbe.httpGet.port}')
if [ "$READINESS_PATH" != "/" ] || [ "$READINESS_PORT" != "80" ]; then
  echo "❌ [FAIL] Readiness probe should check path '/' and port '80', got: path='$READINESS_PATH', port='$READINESS_PORT'"
  exit 1
fi

# Check liveness probe path and port
LIVENESS_PATH=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.path}')
LIVENESS_PORT=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.containers[0].livenessProbe.httpGet.port}')
if [ "$LIVENESS_PATH" != "/" ] || [ "$LIVENESS_PORT" != "80" ]; then
  echo "❌ [FAIL] Liveness probe should check path '/' and port '80', got: path='$LIVENESS_PATH', port='$LIVENESS_PORT'"
  exit 1
fi

echo ""
echo "✅ [PASS] Both readiness and liveness probes are correctly configured."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0