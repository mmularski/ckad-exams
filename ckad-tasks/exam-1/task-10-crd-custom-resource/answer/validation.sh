#!/bin/bash
set -e

NAMESPACE=exam-1-task-10
CRD_NAME=messages.exam.local
CR_NAME=hello-msg

echo "Applying all manifests from prep/ directory..."
kubectl apply -f prep/

# Retry in case of race conditions
kubectl apply -f prep/ --force

# Wait for CRD to be established
kubectl wait --for=condition=Established crd/$CRD_NAME --timeout=30s

# Check CRD configuration
CRD_GROUP=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.group}')
CRD_SCOPE=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.scope}')
CRD_KIND=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.names.kind}')
CRD_PLURAL=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.names.plural}')
CRD_SINGULAR=$(kubectl get crd $CRD_NAME -o jsonpath='{.spec.names.singular}')

if [ "$CRD_GROUP" != "exam.local" ]; then
  echo "❌ [FAIL] CRD group should be exam.local, got: $CRD_GROUP"
  exit 1
fi

if [ "$CRD_SCOPE" != "Namespaced" ]; then
  echo "❌ [FAIL] CRD scope should be Namespaced, got: $CRD_SCOPE"
  exit 1
fi

if [ "$CRD_KIND" != "Message" ]; then
  echo "❌ [FAIL] CRD kind should be Message, got: $CRD_KIND"
  exit 1
fi

if [ "$CRD_PLURAL" != "messages" ]; then
  echo "❌ [FAIL] CRD plural should be messages, got: $CRD_PLURAL"
  exit 1
fi

if [ "$CRD_SINGULAR" != "message" ]; then
  echo "❌ [FAIL] CRD singular should be message, got: $CRD_SINGULAR"
  exit 1
fi

# Check custom resource exists
kubectl get message $CR_NAME -n $NAMESPACE

# Check spec.text field
TEXT=$(kubectl get message $CR_NAME -n $NAMESPACE -o jsonpath='{.spec.text}')
if [ "$TEXT" == "Hello CRD!" ]; then
  echo ""
  echo "✅ [PASS] CustomResourceDefinition and custom resource are correctly configured."
  echo ""

  # Clean up resources on success
  echo "🧹 Cleaning up resources..."
  kubectl delete message "$CR_NAME" -n "$NAMESPACE" --ignore-not-found=true
  kubectl delete crd "$CRD_NAME" --ignore-not-found=true
  kubectl delete namespace "$NAMESPACE" --ignore-not-found=true
  echo "✨ Cleanup completed!"

  exit 0
else
  echo ""
  echo "❌ [FAIL] Custom resource text is incorrect."
  echo ""
  exit 1
fi