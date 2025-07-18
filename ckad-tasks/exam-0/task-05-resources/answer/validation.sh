#!/bin/bash
set -e

NAMESPACE=exam-0-task-05
DEPLOYMENT=prep/deployment.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=resources-demo
EXPECTED_REPLICAS=2
REQ_CPU=100m
REQ_MEM=64Mi
LIM_CPU=200m
LIM_MEM=128Mi

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "[PASS] $EXPECTED_REPLICAS pods are running."
else
  echo "[FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  exit 1
fi

# Check resource requests and limits
POD=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o jsonpath='{.items[0].metadata.name}')
REQ_CPU_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.requests.cpu}')
REQ_MEM_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.requests.memory}')
LIM_CPU_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.limits.cpu}')
LIM_MEM_ACTUAL=$(kubectl get pod $POD -n $NAMESPACE -o jsonpath='{.spec.containers[0].resources.limits.memory}')

if [ "$REQ_CPU_ACTUAL" == "$REQ_CPU" ] && [ "$REQ_MEM_ACTUAL" == "$REQ_MEM" ] && [ "$LIM_CPU_ACTUAL" == "$LIM_CPU" ] && [ "$LIM_MEM_ACTUAL" == "$LIM_MEM" ]; then
  echo "[PASS] Resource requests and limits are set correctly."
  exit 0
else
  echo "[FAIL] Resource requests/limits are incorrect."
  exit 1
fi