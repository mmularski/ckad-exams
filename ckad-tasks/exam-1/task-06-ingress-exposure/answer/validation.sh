#!/bin/bash
set -e

NAMESPACE=exam-1-task-06
DEPLOYMENT=prep/deployment.yaml
SERVICE=prep/service.yaml
INGRESS=prep/ingress.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=web-deployment
SERVICE_NAME=web-service
INGRESS_NAME=web-ingress
EXPECTED_REPLICAS=2
EXPECTED_PORT=80

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"
kubectl apply -f "$SERVICE"
kubectl apply -f "$INGRESS"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=web --field-selector=status.phase=Running --no-headers | wc -l)
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
  echo "✅ [PASS] Service $SERVICE_NAME exposes port $EXPECTED_PORT."
else
  echo ""
  echo "❌ [FAIL] Service $SERVICE_NAME does not expose port $EXPECTED_PORT."
  echo ""
  exit 1
fi

# Check ingress exists and routes to service
if kubectl get ingress $INGRESS_NAME -n $NAMESPACE | grep -q web.exam.local; then
  echo ""
  echo "✅ [PASS] Ingress exists and has correct host."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete ingress "$INGRESS_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete service "$SERVICE_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Ingress not found or host incorrect."
  echo ""
  exit 1
fi