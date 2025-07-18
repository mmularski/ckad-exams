#!/bin/bash
set -e

NAMESPACE=exam-0-task-14
NS_MANIFEST=prep/namespace.yaml
VALUES_GOOD=prep/values-good.yaml
VALUES_BAD=prep/values-bad.yaml
RELEASE=myapp
CHART=nginx

kubectl apply -f "$NS_MANIFEST"

# Install with good values
helm install $RELEASE $CHART --namespace $NAMESPACE -f $VALUES_GOOD --wait

# Upgrade with bad values (should fail)
set +e
helm upgrade $RELEASE $CHART --namespace $NAMESPACE -f $VALUES_BAD
UPGRADE_STATUS=$?
set -e
if [ $UPGRADE_STATUS -eq 0 ]; then
  echo ""
  echo "❌ [FAIL] Upgrade with bad values should fail."
  echo ""
  exit 1
fi

# Rollback
helm rollback $RELEASE 1 --namespace $NAMESPACE

# Check pod status
PODS=$(kubectl get pods -n $NAMESPACE --no-headers | grep Running | wc -l)
if [ "$PODS" -ge 1 ]; then
  echo "✅ [PASS] Application is running after rollback."
else
  echo ""
  echo "❌ [FAIL] Application is not running after rollback."
  echo ""
  exit 1
fi

# Check helm history
if helm history $RELEASE --namespace $NAMESPACE | grep -q 'rollback'; then
  echo ""
  echo "✅ [PASS] Helm history shows rollback."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  helm uninstall "$RELEASE" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Helm history does not show rollback."
  echo ""
  exit 1
fi