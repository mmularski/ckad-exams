# Context Switching Solution Guide

## Overview
This task teaches you how to switch between different Kubernetes namespaces using context switching, which allows you to work with resources without constantly specifying the `-n` flag.

## Key Commands

### 1. List Resources in Specific Namespaces
```bash
# List pods in a specific namespace
kubectl get pods -n exam-0-task-11-1
kubectl get pods -n exam-0-task-11-2
```

### 2. Switch Context to a Namespace
```bash
# Switch to exam-0-task-11-1 namespace
kubectl config set-context --current --namespace=exam-0-task-11-1

# Now you can list pods without -n flag
kubectl get pods  # Lists pods from exam-0-task-11-1
```

### 3. Switch Context to Another Namespace
```bash
# Switch to exam-0-task-11-2 namespace
kubectl config set-context --current --namespace=exam-0-task-11-2

# List pods in the new context
kubectl get pods  # Lists pods from exam-0-task-11-2
```

### 4. Return to Default Namespace
```bash
# Switch back to default namespace
kubectl config set-context --current --namespace=default

# List pods in default namespace
kubectl get pods
```

## Benefits of Context Switching
- **Efficiency**: No need to type `-n namespace` repeatedly
- **Reduced Errors**: Less chance of working in the wrong namespace
- **Better Workflow**: Focus on one namespace at a time
- **Cleaner Commands**: Shorter, more readable kubectl commands

## Best Practices
1. **Check Current Context**: Use `kubectl config view --minify` to see current context
2. **Use Descriptive Names**: Choose namespace names that clearly indicate their purpose
3. **Clean Up**: Always return to default namespace when done
4. **Verify Resources**: Double-check you're in the right namespace before making changes

## Common Use Cases
- **Development**: Switch between dev, staging, and prod namespaces
- **Multi-tenant**: Work with different client namespaces
- **Testing**: Isolate test environments in separate namespaces
- **Troubleshooting**: Focus on specific namespace issues