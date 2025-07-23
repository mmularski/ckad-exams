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

# Check permissions (handle exit codes properly)
GET=$(kubectl auth can-i get pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE 2>/dev/null || echo "no")
LIST=$(kubectl auth can-i list pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE 2>/dev/null || echo "no")
CREATE=$(kubectl auth can-i create pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE 2>/dev/null || echo "no")
DELETE=$(kubectl auth can-i delete pods --as=system:serviceaccount:$NAMESPACE:$SA -n $NAMESPACE 2>/dev/null || echo "no")

# Remove any extra whitespace/newlines and fix "nono" issue
GET=$(echo "$GET" | tr -d '\n\r' | sed 's/nono/no/g')
LIST=$(echo "$LIST" | tr -d '\n\r' | sed 's/nono/no/g')
CREATE=$(echo "$CREATE" | tr -d '\n\r' | sed 's/nono/no/g')
DELETE=$(echo "$DELETE" | tr -d '\n\r' | sed 's/nono/no/g')

if [ "$GET" == "yes" ] && [ "$LIST" == "yes" ] && [ "$CREATE" == "no" ] && [ "$DELETE" == "no" ]; then
  echo ""
  echo "✅ [PASS] ServiceAccount permissions are correct."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete rolebinding read-pods-binding -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete role pod-reader -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete serviceaccount "$SA" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] ServiceAccount permissions are incorrect."
  echo "GET: $GET (expected: yes)"
  echo "LIST: $LIST (expected: yes)"
  echo "CREATE: $CREATE (expected: no)"
  echo "DELETE: $DELETE (expected: no)"
  echo ""
  exit 1
fi