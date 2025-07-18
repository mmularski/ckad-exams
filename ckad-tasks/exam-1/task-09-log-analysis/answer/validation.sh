#!/bin/bash
set -e

NAMESPACE=exam-1-task-09
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
POD_NAME=logger-demo
ERROR_FILE=answer/error.txt
EXPECTED="ERROR: Failed to connect to database"

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

# Check error.txt exists and contains the error line
if [ ! -f "$ERROR_FILE" ]; then
  echo "[FAIL] $ERROR_FILE not found."
  exit 1
fi

if grep -Fxq "$EXPECTED" "$ERROR_FILE"; then
  echo "[PASS] error.txt contains the correct error line."
  exit 0
else
  echo "[FAIL] error.txt does not contain the correct error line."
  exit 1
fi