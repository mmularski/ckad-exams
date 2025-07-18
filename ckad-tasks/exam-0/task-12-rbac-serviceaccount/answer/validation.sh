#!/bin/bash
set -e

NAMESPACE=exam-0-task-12
NS_MANIFEST=prep/namespace.yaml
SA_MANIFEST=prep/serviceaccount.yaml
ROLE_MANIFEST=prep/role.yaml
RB_MANIFEST=prep/rolebinding.yaml
SA=limited-access

kubectl apply -f "$NS_MANIFEST"
kubectl apply -f "$SA_MANIFEST"
kubectl apply -f "$ROLE_MANIFEST"
kubectl apply -f "$RB_MANIFEST"

# Check permissions
GET=$(kubectl auth can-i get pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE)
LIST=$(kubectl auth can-i list pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE)
CREATE=$(kubectl auth can-i create pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE)
DELETE=$(kubectl auth can-i delete pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE)

if [ "$GET" == "yes" ] && [ "$LIST" == "yes" ] && [ "$CREATE" == "no" ] && [ "$DELETE" == "no" ]; then
  echo "[PASS] ServiceAccount permissions are correct."
  exit 0
else
  echo "[FAIL] ServiceAccount permissions are incorrect."
  exit 1
fi