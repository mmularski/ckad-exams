#!/bin/bash
set -e

NAMESPACE=exam-1-task-02
CRONJOB=answer/solution.yaml
NS_MANIFEST=prep/namespace.yaml
CRONJOB_NAME=date-writer

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$CRONJOB"

# Wait for at least one job to be created
for i in {1..10}; do
  JOBS=$(kubectl get jobs -n "$NAMESPACE" -l job-name | grep $CRONJOB_NAME | wc -l)
  if [ "$JOBS" -ge 1 ]; then
    break
  fi
  sleep 10
done
if [ "$JOBS" -lt 1 ]; then
  echo ""
  echo "❌ [FAIL] No jobs created by CronJob."
  echo ""
  exit 1
fi

# Check that the last job completed successfully
LAST_JOB=$(kubectl get jobs -n "$NAMESPACE" -l job-name | grep $CRONJOB_NAME | tail -n1 | awk '{print $1}')
STATUS=$(kubectl get job "$LAST_JOB" -n "$NAMESPACE" -o jsonpath='{.status.succeeded}')
if [ "$STATUS" == "1" ]; then
  echo ""
  echo "✅ [PASS] CronJob created a job that completed successfully."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete cronjob "$CRONJOB_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Last job did not complete successfully."
  echo ""
  exit 1
fi