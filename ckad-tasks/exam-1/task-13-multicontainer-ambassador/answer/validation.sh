#!/bin/bash
set -e

NAMESPACE=exam-1-task-13
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
POD_NAME=ambassador-demo

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
  echo "[FAIL] Pod $POD_NAME is not running (status: $STATUS)"
  exit 1
fi

# Check app logs for HTTP response
LOG=$(kubectl logs "$POD_NAME" -c app -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "HTTP/1.1 200 OK"; then
  echo "[PASS] Ambassador pattern works and HTTP response received."
  exit 0
else
  echo "[FAIL] Ambassador pattern did not work as expected."
  exit 1
fi