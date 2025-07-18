#!/bin/bash
set -e

NAMESPACE=exam-1-task-01
JOB=prep/job.yaml
CONFIGMAP=prep/configmap.yaml
NS_MANIFEST=prep/namespace.yaml
EXPECTED_MSG="HELLO EXAM-1"
JOB_NAME=data-processor

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$CONFIGMAP"
kubectl apply -f "$JOB"

# Wait for job to complete
for i in {1..10}; do
  STATUS=$(kubectl get job "$JOB_NAME" -n "$NAMESPACE" -o jsonpath='{.status.succeeded}' 2>/dev/null || echo "")
  if [ "$STATUS" == "1" ]; then
    break
  fi
  sleep 2
done
if [ "$STATUS" != "1" ]; then
  echo "[FAIL] Job $JOB_NAME did not complete successfully."
  exit 1
fi

# Check job logs for expected message
POD=$(kubectl get pods -n "$NAMESPACE" -l job-name=$JOB_NAME -o jsonpath='{.items[0].metadata.name}')
LOG=$(kubectl logs "$POD" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "$EXPECTED_MSG"; then
  echo "[PASS] Found expected message in job logs."
  exit 0
else
  echo "[FAIL] Expected message not found in job logs."
  exit 1
fi