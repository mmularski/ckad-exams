#!/bin/bash
set -e

NAMESPACE=exam-1-task-05
RQ=prep/resourcequota.yaml
LR=prep/limitrange.yaml
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
POD_NAME=quota-demo

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$RQ"
kubectl apply -f "$LR"
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
  echo "✅ [PASS] Pod has default resource requests and limits."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete limitrange default-limits -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete resourcequota default-quota -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Pod does not have correct default resource requests/limits."
  echo ""
  exit 1
fi