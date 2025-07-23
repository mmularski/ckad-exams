#!/bin/bash
set -e

NAMESPACE=exam-0-task-05
DEPLOYMENT_NAME=resources-demo
EXPECTED_REPLICAS=2
REQ_CPU=100m
REQ_MEM=64Mi
LIM_CPU=200m
LIM_MEM=128Mi
APP_LABEL=web-server

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=$APP_LABEL --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "✅ [PASS] $EXPECTED_REPLICAS pods are running."
else
  echo ""
  echo "❌ [FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  echo ""
  exit 1
fi

# Check resource requests and limits
POD=$(kubectl get pods -n $NAMESPACE -l app=$APP_LABEL -o jsonpath='{.items[0].metadata.name}')
REQ_CPU_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
REQ_MEM_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.requests.memory}')
LIM_CPU_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.limits.cpu}')
LIM_MEM_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.limits.memory}')

if [ "$REQ_CPU_ACTUAL" == "$REQ_CPU" ] && [ "$REQ_MEM_ACTUAL" == "$REQ_MEM" ] && [ "$LIM_CPU_ACTUAL" == "$LIM_CPU" ] && [ "$LIM_MEM_ACTUAL" == "$LIM_MEM" ]; then
  echo ""
  echo "✅ [PASS] Resource requests and limits are set correctly."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Resource requests/limits are incorrect."
  echo ""
  exit 1
fi