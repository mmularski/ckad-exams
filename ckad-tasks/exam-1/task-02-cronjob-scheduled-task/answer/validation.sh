#!/bin/bash
set -e

NAMESPACE=exam-1-task-02
CRONJOB_NAME=date-writer

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Check CronJob schedule
SCHEDULE=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.schedule}')
if [ "$SCHEDULE" != "* * * * *" ]; then
  echo "❌ [FAIL] CronJob schedule should be '* * * * *', got: $SCHEDULE"
  exit 1
fi

# Check if CronJob uses busybox image
IMAGE=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}')
if [[ "$IMAGE" != *"busybox"* ]]; then
  echo "❌ [FAIL] CronJob should use busybox image, got: $IMAGE"
  exit 1
fi

# Check if CronJob has emptyDir volume
VOLUME_TYPE=$(kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.jobTemplate.spec.template.spec.volumes[0].emptyDir}')
if [ -z "$VOLUME_TYPE" ]; then
  echo "❌ [FAIL] CronJob should have emptyDir volume"
  exit 1
fi

# Wait for at least one job to be created
echo "⏳ Waiting for the first job to be created by CronJob (schedule: every minute)..."
for i in {1..10}; do
  JOBS=$(kubectl get jobs -n "$NAMESPACE" -l job-name | grep $CRONJOB_NAME | wc -l)
  if [ "$JOBS" -ge 1 ]; then
    echo "✅ Job created successfully!"
    break
  fi
  echo "   Waiting... (attempt $i/10)"
  sleep 10
done
if [ "$JOBS" -lt 1 ]; then
  echo ""
  echo "❌ [FAIL] No jobs created by CronJob after waiting."
  echo ""
  exit 1
fi

# Check that the last job completed successfully
echo "⏳ Checking if the job completed successfully..."
LAST_JOB=$(kubectl get jobs -n "$NAMESPACE" -l job-name | grep $CRONJOB_NAME | tail -n1 | awk '{print $1}')
STATUS=$(kubectl get job "$LAST_JOB" -n "$NAMESPACE" -o jsonpath='{.status.succeeded}')
if [ "$STATUS" == "1" ]; then
  echo ""
  echo "✅ [PASS] CronJob is correctly configured and created a job that completed successfully."
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