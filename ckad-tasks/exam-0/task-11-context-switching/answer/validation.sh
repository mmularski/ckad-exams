#!/bin/bash
set -e

NS1=ns-one
NS2=ns-two
NS1_MANIFEST=prep/namespace1.yaml
NS2_MANIFEST=prep/namespace2.yaml
POD1_MANIFEST=prep/pod1.yaml
POD2_MANIFEST=prep/pod2.yaml
POD1=pod-one
POD2=pod-two

kubectl apply -f "$NS1_MANIFEST"
kubectl apply -f "$NS2_MANIFEST"
kubectl apply -f "$POD1_MANIFEST"
kubectl apply -f "$POD2_MANIFEST"

# Wait for pods to be running
for ns in $NS1 $NS2; do
  for i in {1..10}; do
    POD=$(kubectl get pods -n $ns --no-headers | head -n1 | awk '{print $1}')
    STATUS=$(kubectl get pod $POD -n $ns -o jsonpath='{.status.phase}' 2>/dev/null || echo "")
    if [ "$STATUS" == "Running" ]; then
      break
    fi
    sleep 1
  done
  if [ "$STATUS" != "Running" ]; then
    echo "[FAIL] Pod in namespace $ns is not running (status: $STATUS)"
    exit 1
  fi
done

# Switch context and check pods
kubectl config set-context --current --namespace=$NS2
PODS=$(kubectl get pods --no-headers | wc -l)
if [ "$PODS" -ge 1 ]; then
  echo "[PASS] Context switch and pod check successful."
  exit 0
else
  echo "[FAIL] No pods found in ns-two after context switch."
  exit 1
fi