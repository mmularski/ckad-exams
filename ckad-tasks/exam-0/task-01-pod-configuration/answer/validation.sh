#!/bin/bash
set -e

NAMESPACE=exam-0-task-01
CONFIGMAP=prep/configmap.yaml
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
EXPECTED_MSG="Hello from ConfigMap!"
POD_NAME=configmap-demo

# Apply manifests
kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$CONFIGMAP"
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
  echo "[FAIL] Pod $POD_NAME is not running (status: $STATUS)"
  exit 1
fi

# Check pod logs for expected message
LOG=$(kubectl logs "$POD_NAME" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "$EXPECTED_MSG"; then
  echo "[PASS] Found expected message in pod logs."
  exit 0
else
  echo "[FAIL] Expected message not found in pod logs."
  exit 1
fi
