#!/bin/bash
set -e

NAMESPACE=exam-0-task-10
NS_MANIFEST=prep/namespace.yaml
FRONTEND=prep/frontend.yaml
BACKEND=prep/backend.yaml
UNRELATED=prep/unrelated.yaml
NETWORKPOLICY=prep/networkpolicy.yaml

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$FRONTEND"
kubectl apply -f "$BACKEND"
kubectl apply -f "$UNRELATED"
kubectl apply -f "$NETWORKPOLICY"

# Wait for pods to be running
for label in frontend backend unrelated; do
  for i in {1..10}; do
    POD=$(kubectl get pods -n $NAMESPACE -l app=$label -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
    STATUS=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
    if [ "$STATUS" == "Running" ]; then
      break
    fi
    sleep 1
  done
  if [ "$STATUS" != "Running" ]; then
    echo ""
    echo "❌ [FAIL] Pod $POD ($label) is not running (status: $STATUS)"
    echo ""
    exit 1
  fi
  # Store pod name in a variable with uppercase label
  case $label in
    frontend) FRONTEND_POD=$POD ;;
    backend) BACKEND_POD=$POD ;;
    unrelated) UNRELATED_POD=$POD ;;
  esac
done

# Wait for backend service to be ready
sleep 5

# Test connectivity: frontend -> backend (should succeed)
kubectl exec -n $NAMESPACE $FRONTEND_POD -- /usr/bin/curl -s --connect-timeout 5 http://backend:80 && FRONTEND_OK=1 || FRONTEND_OK=0
# Test connectivity: unrelated -> backend (should fail)
kubectl exec -n $NAMESPACE $UNRELATED_POD -- /usr/bin/curl -s --connect-timeout 5 http://backend:80 && UNRELATED_OK=1 || UNRELATED_OK=0

if [ "$FRONTEND_OK" -eq 1 ] && [ "$UNRELATED_OK" -eq 0 ]; then
  echo ""
  echo "✅ [PASS] NetworkPolicy works as expected."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete networkpolicy allow-frontend-to-backend -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment frontend -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment backend -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment unrelated -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete service backend -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] NetworkPolicy does not work as expected."
  echo "Frontend connectivity: $FRONTEND_OK (expected: 1)"
  echo "Unrelated connectivity: $UNRELATED_OK (expected: 0)"
  echo ""
  exit 1
fi