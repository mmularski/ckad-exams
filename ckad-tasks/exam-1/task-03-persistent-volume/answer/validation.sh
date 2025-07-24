#!/bin/bash
set -e

NAMESPACE=exam-1-task-03
EXPECTED_MSG="persistent test"
POD_NAME=pv-demo

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Check PersistentVolume configuration
PV_STORAGE=$(kubectl get pv exam1-pv -o jsonpath='{.spec.capacity.storage}')
PV_ACCESS_MODE=$(kubectl get pv exam1-pv -o jsonpath='{.spec.accessModes[0]}')
PV_HOST_PATH=$(kubectl get pv exam1-pv -o jsonpath='{.spec.hostPath.path}')

if [ "$PV_STORAGE" != "1Gi" ]; then
  echo "❌ [FAIL] PersistentVolume storage should be 1Gi, got: $PV_STORAGE"
  exit 1
fi

if [ "$PV_ACCESS_MODE" != "ReadWriteOnce" ]; then
  echo "❌ [FAIL] PersistentVolume accessMode should be ReadWriteOnce, got: $PV_ACCESS_MODE"
  exit 1
fi

if [ "$PV_HOST_PATH" != "/tmp/exam1-pv" ]; then
  echo "❌ [FAIL] PersistentVolume hostPath should be /tmp/exam1-pv, got: $PV_HOST_PATH"
  exit 1
fi

# Check PersistentVolumeClaim configuration
PVC_STORAGE=$(kubectl get pvc exam1-pvc -n "$NAMESPACE" -o jsonpath='{.spec.resources.requests.storage}')
PVC_ACCESS_MODE=$(kubectl get pvc exam1-pvc -n "$NAMESPACE" -o jsonpath='{.spec.accessModes[0]}')

if [ "$PVC_STORAGE" != "1Gi" ]; then
  echo "❌ [FAIL] PersistentVolumeClaim storage should be 1Gi, got: $PVC_STORAGE"
  exit 1
fi

if [ "$PVC_ACCESS_MODE" != "ReadWriteOnce" ]; then
  echo "❌ [FAIL] PersistentVolumeClaim accessMode should be ReadWriteOnce, got: $PVC_ACCESS_MODE"
  exit 1
fi

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
  echo "✅ [PASS] PersistentVolume and PersistentVolumeClaim are correctly configured and file written to persistent volume."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete pod "$POD_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete pvc exam1-pvc -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete pv exam1-pv --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] File not found or content incorrect."
  echo ""
  exit 1
fi