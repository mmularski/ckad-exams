#!/bin/bash
set -e

NAMESPACE=exam-0-task-06
DEPLOYMENT=prep/deployment.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=nginx-deployment
EXPECTED_REPLICAS=3
IMAGE=nginx:1.21

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "[PASS] $EXPECTED_REPLICAS nginx pods are running."
else
  echo "[FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  exit 1
fi

# Check image
IMAGE_OK=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$IMAGE_OK" == "$IMAGE" ]; then
  echo "[PASS] Deployment uses image $IMAGE."
  exit 0
else
  echo "[FAIL] Deployment does not use image $IMAGE."
  exit 1
fi