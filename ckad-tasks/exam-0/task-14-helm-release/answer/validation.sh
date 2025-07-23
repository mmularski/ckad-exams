#!/bin/bash
set -e

NAMESPACE=exam-0-task-14
RELEASE_NAME=myapp

echo "Applying namespace from prep/ directory..."
kubectl apply -f prep/namespace.yaml

# Check if Bitnami repository is added
if ! helm repo list | grep -q "bitnami"; then
    echo ""
    echo "❌ [FAIL] Bitnami repository not found"
    echo "Student must add Bitnami repository with: helm repo add bitnami https://charts.bitnami.com/bitnami"
    echo ""
    exit 1
fi

# Check if PostgreSQL is deployed via Helm
if ! helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo ""
    echo "❌ [FAIL] Helm release '$RELEASE_NAME' not found"
    echo "Student must install PostgreSQL with: helm install $RELEASE_NAME bitnami/postgresql --namespace $NAMESPACE --values prep/values.yaml"
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

# Test database connectivity
echo "Testing database connectivity..."
DB_PASSWORD=$(kubectl exec -it "$RELEASE_NAME"-postgresql-0 -n "$NAMESPACE" -- cat /opt/bitnami/postgresql/secrets/postgres-password | tr -d '\n\r')
kubectl run test-db-connection --rm -i --restart=Never \
  --namespace "$NAMESPACE" \
  --image docker.io/bitnami/postgresql:17.5.0-debian-12-r12 \
  --env="PGPASSWORD=$DB_PASSWORD" \
  --command -- psql --host "$RELEASE_NAME"-postgresql -U postgres -d postgres -c "SELECT 1;" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ [PASS] All validation checks passed! PostgreSQL installation completed successfully."
    echo ""
    echo "📝 To clean up this environment:"
    echo "   helm uninstall $RELEASE_NAME -n $NAMESPACE"
    echo "   kubectl delete pvc data-$RELEASE_NAME-postgresql-0 -n $NAMESPACE  # PVC is NOT automatically deleted"
    echo "   kubectl delete namespace $NAMESPACE"
    echo "   kubectl delete service test-db-connection -n $NAMESPACE"
    echo ""
    exit 0
else
    echo ""
    echo "❌ [FAIL] Cannot connect to database"
    echo ""
    exit 1
fi