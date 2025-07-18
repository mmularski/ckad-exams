#!/bin/bash
set -e

NAMESPACE=exam-0-task-04
POD=prep/pod.yaml
NS_MANIFEST=prep/namespace.yaml
POD_NAME=probes-demo

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$POD"

# Wait for pod to be running
for i in {1..10}; do
  STATUS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
  if [ "$STATUS" == "Running" ]; then
    break
  fi
  sleep 1
done
if [ "$STATUS" != "Running" ]; then
  echo "[FAIL] Pod $POD_NAME is not running (status: $STATUS)"
  exit 1
fi

# Check for readiness and liveness probes in the manifest
READINESS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o json | grep readinessProbe)
LIVENESS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o json | grep livenessProbe)
if [ -n "$READINESS" ] && [ -n "$LIVENESS" ]; then
  echo "[PASS] Both readiness and liveness probes are configured."
  exit 0
else
  echo "[FAIL] Readiness and/or liveness probe is missing."
  exit 1
fi