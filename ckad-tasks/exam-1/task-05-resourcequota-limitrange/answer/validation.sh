#!/bin/bash
set -e

NAMESPACE=exam-1-task-05
POD_NAME=quota-demo

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Check ResourceQuota configuration
RQ_CPU_REQ=$(kubectl get resourcequota compute-quota -n "$NAMESPACE" -o jsonpath='{.spec.hard.requests\.cpu}')
RQ_MEM_REQ=$(kubectl get resourcequota compute-quota -n "$NAMESPACE" -o jsonpath='{.spec.hard.requests\.memory}')
RQ_CPU_LIM=$(kubectl get resourcequota compute-quota -n "$NAMESPACE" -o jsonpath='{.spec.hard.limits\.cpu}')
RQ_MEM_LIM=$(kubectl get resourcequota compute-quota -n "$NAMESPACE" -o jsonpath='{.spec.hard.limits\.memory}')

if [ "$RQ_CPU_REQ" != "500m" ]; then
  echo "❌ [FAIL] ResourceQuota requests.cpu should be 500m, got: $RQ_CPU_REQ"
  exit 1
fi

if [ "$RQ_MEM_REQ" != "256Mi" ]; then
  echo "❌ [FAIL] ResourceQuota requests.memory should be 256Mi, got: $RQ_MEM_REQ"
  exit 1
fi

if [ "$RQ_CPU_LIM" != "500m" ]; then
  echo "❌ [FAIL] ResourceQuota limits.cpu should be 500m, got: $RQ_CPU_LIM"
  exit 1
fi

if [ "$RQ_MEM_LIM" != "256Mi" ]; then
  echo "❌ [FAIL] ResourceQuota limits.memory should be 256Mi, got: $RQ_MEM_LIM"
  exit 1
fi

# Check LimitRange configuration
LR_DEF_CPU=$(kubectl get limitrange default-limits -n "$NAMESPACE" -o jsonpath='{.spec.limits[0].default.cpu}')
LR_DEF_MEM=$(kubectl get limitrange default-limits -n "$NAMESPACE" -o jsonpath='{.spec.limits[0].default.memory}')
LR_DEF_REQ_CPU=$(kubectl get limitrange default-limits -n "$NAMESPACE" -o jsonpath='{.spec.limits[0].defaultRequest.cpu}')
LR_DEF_REQ_MEM=$(kubectl get limitrange default-limits -n "$NAMESPACE" -o jsonpath='{.spec.limits[0].defaultRequest.memory}')

if [ "$LR_DEF_CPU" != "200m" ]; then
  echo "❌ [FAIL] LimitRange default cpu should be 200m, got: $LR_DEF_CPU"
  exit 1
fi

if [ "$LR_DEF_MEM" != "128Mi" ]; then
  echo "❌ [FAIL] LimitRange default memory should be 128Mi, got: $LR_DEF_MEM"
  exit 1
fi

if [ "$LR_DEF_REQ_CPU" != "100m" ]; then
  echo "❌ [FAIL] LimitRange defaultRequest cpu should be 100m, got: $LR_DEF_REQ_CPU"
  exit 1
fi

if [ "$LR_DEF_REQ_MEM" != "64Mi" ]; then
  echo "❌ [FAIL] LimitRange defaultRequest memory should be 64Mi, got: $LR_DEF_REQ_MEM"
  exit 1
fi

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

# Check resource requests and limits
REQ_CPU=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
REQ_MEM=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.requests.memory}')
LIM_CPU=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.limits.cpu}')
LIM_MEM=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.limits.memory}')

if [ "$REQ_CPU" == "100m" ] && [ "$REQ_MEM" == "64Mi" ] && [ "$LIM_CPU" == "200m" ] && [ "$LIM_MEM" == "128Mi" ]; then
  echo ""
  echo "✅ [PASS] ResourceQuota and LimitRange are correctly configured and pod has default resource requests and limits."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete limitrange default-limits -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete resourcequota compute-quota -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Pod does not have correct default resource requests/limits."
  echo ""
  exit 1
fi