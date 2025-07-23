# Solution for Task 14: Helm Setup and PostgreSQL Installation

## Step-by-Step Instructions

### Step 1: Apply the namespace
```bash
kubectl apply -f prep/namespace.yaml
```

### Step 2: Add Bitnami Helm repository
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Step 3: Update Helm repositories
```bash
helm repo update
```

### Step 4: Install PostgreSQL using Helm
```bash
helm install myapp bitnami/postgresql \
  --namespace exam-0-task-14 \
  --values prep/values.yaml
```

### Step 5: Wait for the deployment to be ready
```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql -n exam-0-task-14 --timeout=300s
```

### Step 6: Verify the installation
```bash
# Check if the release is installed
helm list -n exam-0-task-14

# Check if pods are running
kubectl get pods -n exam-0-task-14

# Check if the secret was created
kubectl get secrets -n exam-0-task-14
```

### Step 7: Test database connectivity
```bash
# Get the password from the pod (this is the correct way)
DB_PASSWORD=$(kubectl exec -it myapp-postgresql-0 -n exam-0-task-14 -- cat /opt/bitnami/postgresql/secrets/postgres-password | tr -d '\n\r')

# Test connection
kubectl run test-db-connection --rm -i --restart=Never \
  --namespace exam-0-task-14 \
  --image docker.io/bitnami/postgresql:17.5.0-debian-12-r12 \
  --env="PGPASSWORD=$DB_PASSWORD" \
  --command -- psql --host myapp-postgresql -U postgres -d postgres -c "SELECT 1;"
```

## Expected Configuration

The `prep/values.yaml` file contains:
- Database name: `oldapp`
- Password: `oldpassword123`
- Storage size: `5Gi`
- CPU request: `100m`, limit: `200m`
- Memory request: `256Mi`, limit: `512Mi`
- Fullname override: `legacy-postgresql`

## Important Notes

- **Release name**: Use `myapp` as the release name
- **Namespace**: Use `exam-0-task-14` namespace
- **Values file**: Use `prep/values.yaml` for configuration
- **Password**: PostgreSQL uses the password from `/opt/bitnami/postgresql/secrets/postgres-password` inside the pod, not from the Kubernetes secret
- **Password handling**: Use `tr -d '\n\r'` to remove newlines and carriage returns from the password

## Validation

Run the validation script to verify your solution:
```bash
./answer/validation.sh
```

## Troubleshooting

### If the installation fails:
1. Check if the namespace exists: `kubectl get namespace exam-0-task-14`
2. Check if Bitnami repo is added: `helm repo list`
3. Check if the values file exists: `ls -la prep/values.yaml`
4. Make sure you're using release name `myapp`

### If pods are not running:
1. Check pod status: `kubectl get pods -n exam-0-task-14`
2. Check pod logs: `kubectl logs myapp-postgresql-0 -n exam-0-task-14`
3. Check events: `kubectl get events -n exam-0-task-14`

### If database connection fails:
1. Check if the secret exists: `kubectl get secrets -n exam-0-task-14`
2. Get the password from the pod: `kubectl exec -it myapp-postgresql-0 -n exam-0-task-14 -- cat /opt/bitnami/postgresql/secrets/postgres-password`
3. Check if the service is available: `kubectl get svc -n exam-0-task-14`
4. Test connection directly from the pod: `kubectl exec -it myapp-postgresql-0 -n exam-0-task-14 -- bash -c "PGPASSWORD=\$(cat /opt/bitnami/postgresql/secrets/postgres-password | tr -d '\n\r') psql -U postgres -d postgres -c 'SELECT 1;'"`