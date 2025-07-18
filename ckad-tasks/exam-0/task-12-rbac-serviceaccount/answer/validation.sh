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
  echo ""
  echo "✅ [PASS] ServiceAccount permissions are correct."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete rolebinding limited-access-binding -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete role limited-access-role -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete serviceaccount "$SA" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] ServiceAccount permissions are incorrect."
  echo ""
  exit 1
fi