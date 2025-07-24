#!/bin/bash
set -e

NS_A=ns-a
NS_B=ns-b
BACKEND=backend
CLIENT=client

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for pods to be running
for ns in $NS_A $NS_B; do
  for i in {1..10}; do
    POD=$(kubectl get pods -n $ns --no-headers | head -n1 | awk '{print $1}')
    STATUS=$(kubectl get pod $POD -n $ns -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
    if [ "$STATUS" == "Running" ]; then
      break
    fi
    sleep 2
  done
  if [ "$STATUS" != "Running" ]; then
    echo ""
    echo "❌ [FAIL] Pod in namespace $ns is not running (status: $STATUS)"
    echo ""
    exit 1
  fi
done

# Test connectivity: client -> backend (should succeed)
kubectl exec -n $NS_B $CLIENT -- wget -qO- --timeout=2 http://backend.ns-a.svc.cluster.local:80 && CLIENT_OK=1 || CLIENT_OK=0
# Test connectivity: backend -> backend (should fail)
kubectl exec -n $NS_A $BACKEND -- wget -qO- --timeout=2 http://backend:80 && BACKEND_OK=1 || BACKEND_OK=0

if [ "$CLIENT_OK" -eq 1 ] && [ "$BACKEND_OK" -eq 0 ]; then
  echo ""
  echo "✅ [PASS] NetworkPolicy works as expected."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete networkpolicy allow-from-ns-b -n "$NS_A" --ignore-not-found=true
  kubectl delete pod "$BACKEND" -n "$NS_A" --ignore-not-found=true
  kubectl delete pod "$CLIENT" -n "$NS_B" --ignore-not-found=true
  kubectl delete namespace "$NS_A" --ignore-not-found=true
  kubectl delete namespace "$NS_B" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] NetworkPolicy does not work as expected."
  echo ""
  exit 1
fi