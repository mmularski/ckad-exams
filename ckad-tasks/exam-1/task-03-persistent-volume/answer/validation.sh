#!/bin/bash
set -e

NAMESPACE=exam-1-task-03
PV=prep/pv.yaml
PVC=prep/pvc.yaml
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
EXPECTED_MSG="persistent test"
POD_NAME=pv-demo

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$PV"
kubectl apply -f "$PVC"
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

# Check file in the volume
if kubectl exec -n "$NAMESPACE" "$POD_NAME" -- cat /data/test.txt | grep -q "$EXPECTED_MSG"; then
  echo ""
  echo "✅ [PASS] File written to persistent volume."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete pvc data-pvc -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete pv data-pv --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] File not found or content incorrect."
  echo ""
  exit 1
fi