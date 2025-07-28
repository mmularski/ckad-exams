#!/bin/bash
set -e

NAMESPACE=exam-1-task-13
POD_NAME=ambassador-demo

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

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

# Wait for wget to complete (sleep 3 + wget timeout)
echo "Waiting for wget to complete..."
sleep 8

# Check app container logs for successful communication
LOG=$(kubectl logs "$POD_NAME" -c app -n "$NAMESPACE" 2>/dev/null || true)
if echo "$LOG" | grep -q "HTTP/1.1 200 OK\|200 OK\|200" && echo "$LOG" | grep -q "Example Domain"; then
  echo ""
  echo "✅ [PASS] Ambassador pattern works and communication successful."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Ambassador pattern did not work as expected."
  echo "📋 App logs:"
  echo "$LOG"
  echo ""
  exit 1
fi