#!/bin/bash
set -e

NAMESPACE=exam-1-task-06
DEPLOYMENT_NAME=web-deployment
SERVICE_NAME=web-service
INGRESS_NAME=web-ingress
EXPECTED_REPLICAS=2
EXPECTED_PORT=80

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

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

# Check Ingress configuration
INGRESS_HOST=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].host}')
INGRESS_PATH=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].http.paths[0].path}')
INGRESS_PATH_TYPE=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].http.paths[0].pathType}')
INGRESS_SERVICE=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}')
INGRESS_PORT=$(kubectl get ingress $INGRESS_NAME -n $NAMESPACE -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}')

if [ "$INGRESS_HOST" != "web.exam.local" ]; then
  echo "❌ [FAIL] Ingress host should be web.exam.local, got: $INGRESS_HOST"
  exit 1
fi

if [ "$INGRESS_PATH" != "/" ]; then
  echo "❌ [FAIL] Ingress path should be /, got: $INGRESS_PATH"
  exit 1
fi

if [ "$INGRESS_PATH_TYPE" != "Prefix" ]; then
  echo "❌ [FAIL] Ingress pathType should be Prefix, got: $INGRESS_PATH_TYPE"
  exit 1
fi

if [ "$INGRESS_SERVICE" != "web-service" ]; then
  echo "❌ [FAIL] Ingress should route to web-service, got: $INGRESS_SERVICE"
  exit 1
fi

if [ "$INGRESS_PORT" != "80" ]; then
  echo "❌ [FAIL] Ingress should route to port 80, got: $INGRESS_PORT"
  exit 1
fi

  echo ""
echo "✅ [PASS] Ingress is correctly configured and routes traffic to the service."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete ingress "$INGRESS_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete service "$SERVICE_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0