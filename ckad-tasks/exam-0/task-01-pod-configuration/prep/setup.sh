#!/bin/bash
set -e

# Usage: ./setup.sh [namespace-file.yaml] [resource-file.yaml ...]
# This script applies the given namespace and resource manifests idempotently.

if [ $# -lt 1 ]; then
  echo "Usage: $0 <namespace.yaml> [resource1.yaml resource2.yaml ...]"
  exit 1
fi

NAMESPACE_FILE="$1"
shift

# Apply namespace manifest
kubectl apply -f "$NAMESPACE_FILE"

# Apply additional resource manifests, if any
for resource in "$@"; do
  kubectl apply -f "$resource"
done

echo "Setup complete."
