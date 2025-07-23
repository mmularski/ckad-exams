# Solution for Task 15: Helm Chart Upgrade

## Step-by-Step Instructions

### Prerequisites
Make sure Task 14 is completed and PostgreSQL is running in the `exam-0-task-14` namespace with release name `myapp`.

### Step 1: Apply the namespace
```bash
kubectl apply -f prep/namespace.yaml
```

### Step 2: Create the upgrade values file
Create `prep/values-upgrade.yaml` with the following content:

```yaml
postgresql:
  enabled: true
  primary:
    resources:
      requests:
        cpu: 200m
        memory: 384Mi
      limits:
        cpu: 300m
        memory: 640Mi
```

### Step 3: Perform the upgrade
```bash
helm upgrade myapp bitnami/postgresql \
  --namespace exam-0-task-14 \
  --values prep/values-upgrade.yaml \
  --wait
```

### Step 4: Wait for the upgrade to complete
```bash
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql -n exam-0-task-14 --timeout=300s
```

### Step 5: Verify the upgrade
```bash
# Check if the release was upgraded
helm list -n exam-0-task-14

# Check if pods are running
kubectl get pods -n exam-0-task-14

# Check the new configuration
helm get values myapp -n exam-0-task-14
```



## Expected Changes

The upgrade should change:
- **CPU request**: `100m` → `200m` (should change)
- **Memory request**: `256Mi` → `384Mi` (should change)



## Important Notes

- **Release name**: Use `myapp` as the release name
- **Namespace**: Use `exam-0-task-14` namespace (same as Task 14)
- **Values file**: Create `prep/values-upgrade.yaml` for the new configuration
- **Password**: PostgreSQL uses the password from `/opt/bitnami/postgresql/secrets/postgres-password` inside the pod

### What Should Change
- **Resources** (CPU, memory) - These are applied to new pods
- **Configuration** - Non-persistent configuration values



## Validation

Run the validation script to verify your solution:
```bash
./answer/validation.sh
```

## Troubleshooting

### If the upgrade fails:
1. Check if the release exists: `helm list -n exam-0-task-15`
2. Check if the values file exists: `ls -la prep/values-upgrade.yaml`
3. Check upgrade status: `helm status myapp -n exam-0-task-15`
4. Make sure you're using release name `myapp`

### If pods are not running after upgrade:
1. Check pod status: `kubectl get pods -n exam-0-task-15`
2. Check pod logs: `kubectl logs myapp-postgresql-0 -n exam-0-task-15`
3. Check events: `kubectl get events -n exam-0-task-15`

