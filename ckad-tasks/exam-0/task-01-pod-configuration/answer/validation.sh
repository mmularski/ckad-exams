#!/bin/bash
set -e

# Usage: ./validation.sh [namespace] [resource-type] [resource-name]
# This script validates the existence and configuration of a Kubernetes resource.
# It also provides cleanup functionality.

NAMESPACE="$1"
RESOURCE_TYPE="$2"
RESOURCE_NAME="$3"

if [ -z "$NAMESPACE" ] || [ -z "$RESOURCE_TYPE" ] || [ -z "$RESOURCE_NAME" ]; then
  echo "Usage: $0 <namespace> <resource-type> <resource-name>"
  exit 1
fi

function success() {
  echo -e "\e[32m[SUCCESS]\e[0m $1"
}

function failure() {
  echo -e "\e[31m[FAILURE]\e[0m $1"
  exit 1
}

function cleanup() {
  echo "Cleaning up resources..."
  kubectl delete $RESOURCE_TYPE $RESOURCE_NAME -n $NAMESPACE --ignore-not-found
  echo "Cleanup complete."
}

# Trap for cleanup on exit
trap cleanup EXIT

# Validation logic
if ! kubectl get $RESOURCE_TYPE $RESOURCE_NAME -n $NAMESPACE &>/dev/null; then
  failure "$RESOURCE_TYPE/$RESOURCE_NAME does not exist in namespace $NAMESPACE."
fi

# Add additional configuration checks here as needed
# Example: Check if a pod is running
if [ "$RESOURCE_TYPE" == "pod" ]; then
  STATUS=$(kubectl get pod $RESOURCE_NAME -n $NAMESPACE -o jsonpath='{.status.phase}')
  if [ "$STATUS" != "Running" ]; then
    failure "Pod $RESOURCE_NAME is not running (status: $STATUS)."
  fi
fi

success "$RESOURCE_TYPE/$RESOURCE_NAME exists and passed validation."
