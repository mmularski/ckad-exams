#!/bin/bash
set -e

NAMESPACE=exam-1-task-15
DEPLOYMENT_NAME=rolling-demo
EXPECTED_REPLICAS=3
EXPECTED_IMAGE=nginx:1.22

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=60s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=rolling-demo --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "✅ [PASS] $EXPECTED_REPLICAS nginx pods are running."
else
  echo ""
  echo "❌ [FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  echo ""
  exit 1
fi

# Check image
IMAGE=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE" == "$EXPECTED_IMAGE" ]; then
  echo "✅ [PASS] Deployment uses image $EXPECTED_IMAGE."
else
  echo ""
  echo "❌ [FAIL] Deployment does not use image $EXPECTED_IMAGE."
  echo ""
  exit 1
fi

# Check rolling update strategy
MAX_UNAVAIL=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
MAX_SURGE=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
if [ "$MAX_UNAVAIL" == "1" ] && [ "$MAX_SURGE" == "2" ]; then
  echo ""
  echo "✅ [PASS] Rolling update strategy is correct."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Rolling update strategy is incorrect."
  echo ""
  exit 1
fi