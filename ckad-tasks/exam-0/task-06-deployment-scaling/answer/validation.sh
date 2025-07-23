#!/bin/bash
set -e

NAMESPACE=exam-0-task-06
DEPLOYMENT=prep/deployment.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=nginx-deployment
EXPECTED_REPLICAS=3
IMAGE=nginx:1.21

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods - use deployment name as selector
RUNNING=$(kubectl get pods -n $NAMESPACE --field-selector=status.phase=Running --no-headers | grep $DEPLOYMENT_NAME | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "✅ [PASS] $EXPECTED_REPLICAS nginx pods are running."
else
  echo ""
  echo "❌ [FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  echo ""
  exit 1
fi

# Check image
IMAGE_OK=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE_OK" == "$IMAGE" ]; then
  echo ""
  echo "✅ [PASS] Deployment uses image $IMAGE."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Deployment does not use image $IMAGE."
  echo ""
  exit 1
fi