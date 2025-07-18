#!/bin/bash
set -e

NAMESPACE=exam-1-task-15
DEPLOYMENT=prep/deployment.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=rolling-demo
EXPECTED_REPLICAS=3
EXPECTED_IMAGE=nginx:1.22

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=60s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=rolling-demo --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "[PASS] $EXPECTED_REPLICAS nginx pods are running."
else
  echo "[FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  exit 1
fi

# Check image
IMAGE=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE" == "$EXPECTED_IMAGE" ]; then
  echo "[PASS] Deployment uses image $EXPECTED_IMAGE."
else
  echo "[FAIL] Deployment does not use image $EXPECTED_IMAGE."
  exit 1
fi

# Check rolling update strategy
MAX_UNAVAIL=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
MAX_SURGE=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
if [ "$MAX_UNAVAIL" == "1" ] && [ "$MAX_SURGE" == "2" ]; then
  echo "[PASS] Rolling update strategy is correct."
  exit 0
else
  echo "[FAIL] Rolling update strategy is incorrect."
  exit 1
fi