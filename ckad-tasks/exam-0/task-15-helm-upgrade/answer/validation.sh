#!/bin/bash
set -e

NAMESPACE=exam-0-task-14
RELEASE_NAME=myapp

echo "Applying namespace from prep/ directory..."
kubectl apply -f prep/namespace.yaml

# Check if student created values-upgrade.yaml
if [ ! -f "prep/values-upgrade.yaml" ]; then
    echo ""
    echo "❌ [FAIL] prep/values-upgrade.yaml not found"
    echo ""
    exit 1
fi

# Check if PostgreSQL is deployed via Helm
if ! helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo ""
    echo "❌ [FAIL] Helm release '$RELEASE_NAME' not found"
    echo "Make sure Task 14 is completed and PostgreSQL is running"
    echo ""
    exit 1
fi

# Check if upgrade was performed by student
echo "Checking if upgrade was performed..."

# Check if resources were updated via Helm values
echo "Checking resource configuration..."
HELM_CPU_REQUEST=$(helm get values "$RELEASE_NAME" -n "$NAMESPACE" -o json | jq -r '.postgresql.primary.resources.requests.cpu // "not_set"')
HELM_MEMORY_REQUEST=$(helm get values "$RELEASE_NAME" -n "$NAMESPACE" -o json | jq -r '.postgresql.primary.resources.requests.memory // "not_set"')

if [ "$HELM_CPU_REQUEST" != "200m" ]; then
    echo ""
    echo "❌ [FAIL] CPU request not updated in Helm values. Expected: 200m, Got: $HELM_CPU_REQUEST"
    echo ""
    exit 1
fi

if [ "$HELM_MEMORY_REQUEST" != "384Mi" ]; then
    echo ""
    echo "❌ [FAIL] Memory request not updated in Helm values. Expected: 384Mi, Got: $HELM_MEMORY_REQUEST"
    echo ""
    exit 1
fi



# Check pod status
POD_STATUS=$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=postgresql -o jsonpath='{.items[0].status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
    echo ""
    echo "❌ [FAIL] Pod is not running. Status: $POD_STATUS"
    echo ""
    exit 1
fi

# Check pod status
POD_STATUS=$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=postgresql -o jsonpath='{.items[0].status.phase}')
if [ "$POD_STATUS" != "Running" ]; then
    echo ""
    echo "❌ [FAIL] Pod is not running. Status: $POD_STATUS"
    echo ""
    exit 1
fi

echo ""
echo "✅ [PASS] All validation checks passed! Upgrade completed successfully."
echo ""
echo "📝 To clean up this environment:"
echo "   helm uninstall $RELEASE_NAME -n $NAMESPACE"
echo "   kubectl delete pvc data-$RELEASE_NAME-postgresql-0 -n $NAMESPACE"
echo "   kubectl delete namespace $NAMESPACE"
echo ""
exit 0