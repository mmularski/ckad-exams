#!/bin/bash
set -e

NAMESPACE=exam-1-task-01
EXPECTED_MSG="HELLO EXAM-1"
JOB_NAME=data-processor

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for job to complete
for i in {1..10}; do
  STATUS=$(kubectl get job "$JOB_NAME" -n "$NAMESPACE" -o jsonpath='{.status.succeeded}' 2>/dev/null || echo "")
  if [ "$STATUS" == "1" ]; then
    break
  fi
  sleep 2
done
if [ "$STATUS" != "1" ]; then
  echo ""
  echo "❌ [FAIL] Job $JOB_NAME did not complete successfully."
  echo ""
  exit 1
fi

# Check job logs for expected message
POD=$(kubectl get pods -n "$NAMESPACE" -l job-name=$JOB_NAME -o jsonpath='{.items[0].metadata.name}')
LOG=$(kubectl logs "$POD" -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "$EXPECTED_MSG"; then
  echo ""
  echo "✅ [PASS] Found expected message in job logs."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete job "$JOB_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete configmap data-input -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Expected message not found in job logs."
  echo "📋 Job logs:"
  echo "$LOG"
  echo ""
  exit 1
fi