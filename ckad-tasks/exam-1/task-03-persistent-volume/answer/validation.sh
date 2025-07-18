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
  echo "[FAIL] Pod $POD_NAME is not running (status: $STATUS)"
  exit 1
fi

# Check file in the volume
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- cat /data/test.txt | grep -q "$EXPECTED_MSG" && \
  echo "[PASS] File written to persistent volume." && exit 0

echo "[FAIL] File not found or content incorrect."
exit 1