#!/bin/bash
set -e

NAMESPACE=exam-1-task-07
DEPLOYMENT_NAME=ha-app
PDB_NAME=ha-pdb
EXPECTED_REPLICAS=3

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

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

# Check PDB configuration
MIN_AVAIL=$(kubectl get pdb $PDB_NAME -n $NAMESPACE -o jsonpath='{.spec.minAvailable}')
PDB_SELECTOR=$(kubectl get pdb $PDB_NAME -n $NAMESPACE -o jsonpath='{.spec.selector.matchLabels.app}')

if [ "$MIN_AVAIL" != "2" ]; then
  echo "❌ [FAIL] PDB minAvailable should be 2, got: $MIN_AVAIL"
  exit 1
fi

if [ "$PDB_SELECTOR" != "ha-app" ]; then
  echo "❌ [FAIL] PDB selector should match app=ha-app, got: $PDB_SELECTOR"
  exit 1
fi

  echo ""
echo "✅ [PASS] PodDisruptionBudget is correctly configured with minAvailable=2 and proper selector."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete poddisruptionbudget "$PDB_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0