#!/bin/bash
set -e

NAMESPACE=exam-1-task-02
CRONJOB=prep/cronjob.yaml
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
  echo "[FAIL] No jobs created by CronJob."
  exit 1
fi

# Check that the last job completed successfully
LAST_JOB=$(kubectl get jobs -n "$NAMESPACE" -l job-name | grep $CRONJOB_NAME | tail -n1 | awk '{print $1}')
STATUS=$(kubectl get job "$LAST_JOB" -n "$NAMESPACE" -o jsonpath='{.status.succeeded}')
if [ "$STATUS" == "1" ]; then
  echo "[PASS] CronJob created a job that completed successfully."
  exit 0
else
  echo "[FAIL] Last job did not complete successfully."
  exit 1
fi