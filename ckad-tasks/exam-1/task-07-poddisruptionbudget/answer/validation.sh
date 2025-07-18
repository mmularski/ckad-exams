#!/bin/bash
set -e

NAMESPACE=exam-1-task-07
DEPLOYMENT=prep/deployment.yaml
PDB=prep/pdb.yaml
NS_MANIFEST=prep/namespace.yaml
DEPLOYMENT_NAME=ha-app
PDB_NAME=ha-pdb
EXPECTED_REPLICAS=3

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$DEPLOYMENT"
kubectl apply -f "$PDB"

# Wait for deployment to be ready
kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE --timeout=30s

# Check number of running pods
RUNNING=$(kubectl get pods -n $NAMESPACE -l app=ha-app --field-selector=status.phase=Running --no-headers | wc -l)
if [ "$RUNNING" -eq "$EXPECTED_REPLICAS" ]; then
  echo "✅ [PASS] $EXPECTED_REPLICAS nginx pods are running."
else
  echo ""
  echo "❌ [FAIL] Expected $EXPECTED_REPLICAS running pods, found $RUNNING."
  echo ""
  exit 1
fi

# Check PDB exists and minAvailable is 2
MIN_AVAIL=$(kubectl get pdb $PDB_NAME -n $NAMESPACE -o jsonpath='{.spec.minAvailable}')
if [ "$MIN_AVAIL" == "2" ]; then
  echo ""
  echo "✅ [PASS] PDB minAvailable is set to 2."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete poddisruptionbudget "$PDB_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] PDB minAvailable is not set to 2."
  echo ""
  exit 1
fi