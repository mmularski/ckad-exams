#!/bin/bash
set -e

NAMESPACE=exam-0-task-07
DEPLOYMENT=prep/deployment.yaml
SERVICE=prep/service.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=web-deployment
SERVICE_NAME=web-service
EXPECTED_REPLICAS=2
EXPECTED_PORT=80
IMAGE=nginx:1.21

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"
kubectl apply -f "$SERVICE"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "✅ [PASS] $EXPECTED_REPLICAS nginx pods are running."
else
  echo ""
  echo "❌ [FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  echo ""
  exit 1
fi

# Check service exists and exposes port 80
PORT=$(kubectl get svc $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].port}')
if [ "$PORT" == "$EXPECTED_PORT" ]; then
  echo ""
  echo "✅ [PASS] Service $SERVICE_NAME exposes port $EXPECTED_PORT."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete service "$SERVICE_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Service $SERVICE_NAME does not expose port $EXPECTED_PORT."
  echo ""
  exit 1
fi