# Helm Deployment and Rollback Guide

1. **Install the chart:**
   ```
   helm install my-release ./chart -n exam-0-task-14 -f prep/values-good.yaml
   ```
2. **Upgrade with a bad values file (simulate failure):**
   ```
   helm upgrade my-release ./chart -n exam-0-task-14 -f prep/values-bad.yaml
   ```
3. **Check rollout status and history:**
   ```
   helm history my-release -n exam-0-task-14
   kubectl get pods -n exam-0-task-14
   ```
4. **Rollback to the previous working release:**
   ```
   helm rollback my-release <REVISION> -n exam-0-task-14
   ```
   Replace `<REVISION>` with the revision number of the last successful release (see `helm history`).
5. **Verify the deployment is healthy:**
   ```
   kubectl get pods -n exam-0-task-14
   ```
