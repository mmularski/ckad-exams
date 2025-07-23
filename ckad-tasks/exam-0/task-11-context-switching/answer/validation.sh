#!/bin/bash
set -e

echo "Setting up environment..."
kubectl apply -f prep/

# Wait for pods to be running
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=Ready pod/pod-one -n exam-0-task-11-1 --timeout=30s
kubectl wait --for=condition=Ready pod/pod-two -n exam-0-task-11-2 --timeout=30s

echo ""
echo "Testing context switching skills..."
echo ""

# Test 1: List pods with -n flag
echo "Test 1: Listing pods with -n flag"
PODS_NS1=$(kubectl get pods -n exam-0-task-11-1 -o jsonpath='{.items[*].metadata.name}')
PODS_NS2=$(kubectl get pods -n exam-0-task-11-2 -o jsonpath='{.items[*].metadata.name}')

if [[ "$PODS_NS1" == "pod-one" && "$PODS_NS2" == "pod-two" ]]; then
    echo "✅ Pods found correctly in both namespaces"
else
    echo "❌ Pods not found correctly"
    echo "Namespace 1 pods: $PODS_NS1"
    echo "Namespace 2 pods: $PODS_NS2"
    exit 1
fi

# Test 2: Switch context and list pods without -n
echo ""
echo "Test 2: Context switching to exam-0-task-11-1"
kubectl config set-context --current --namespace=exam-0-task-11-1
PODS_CONTEXT1=$(kubectl get pods -o jsonpath='{.items[*].metadata.name}')

if [[ "$PODS_CONTEXT1" == "pod-one" ]]; then
    echo "✅ Context switch to exam-0-task-11-1 successful"
else
    echo "❌ Context switch failed"
    echo "Pods in context: $PODS_CONTEXT1"
    exit 1
fi

echo ""
echo "Test 3: Context switching to exam-0-task-11-2"
kubectl config set-context --current --namespace=exam-0-task-11-2
PODS_CONTEXT2=$(kubectl get pods -o jsonpath='{.items[*].metadata.name}')

if [[ "$PODS_CONTEXT2" == "pod-two" ]]; then
    echo "✅ Context switch to exam-0-task-11-2 successful"
else
    echo "❌ Context switch failed"
    echo "Pods in context: $PODS_CONTEXT2"
    exit 1
fi

# Test 4: Return to default namespace
echo ""
echo "Test 4: Returning to default namespace"
kubectl config set-context --current --namespace=default
DEFAULT_PODS=$(kubectl get pods -o jsonpath='{.items[*].metadata.name}' 2>/dev/null || echo "")

echo "✅ Returned to default namespace"
echo "Default namespace pods: $DEFAULT_PODS"

echo ""
echo "✅ [PASS] All context switching tests passed!"

# Clean up
echo ""
echo "🧹 Cleaning up resources..."
kubectl delete namespace exam-0-task-11-1 --ignore-not-found=true
kubectl delete namespace exam-0-task-11-2 --ignore-not-found=true
echo "✨ Cleanup completed!"