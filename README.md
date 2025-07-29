# CKAD Practice Exams Collection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-blue.svg)](https://kubernetes.io/)
[![CKAD](https://img.shields.io/badge/CKAD-Certified%20Kubernetes%20Application%20Developer-orange.svg)](https://www.cncf.io/certification/ckad/)

> **Comprehensive collection of practice exams for CKAD certification with realistic scenarios and automated validation**

## 🎯 Overview

This repository contains a collection of **practice exam sets** designed to help developers prepare for the **Certified Kubernetes Application Developer (CKAD)** exam. Each exam set includes 15 realistic tasks covering all CKAD curriculum domains, with automated validation scripts and complete solutions.

## ✨ Key Features

### 📝 **Complete Practice Exams**
- **15-20 tasks per exam set** covering all CKAD curriculum domains
- **Real-world scenarios** reflecting actual production use cases
- **Progressive difficulty** from simple to complex implementations
- **Time-constrained practice** (5-10 minutes per task) matching exam conditions

### 🔧 **Automated Validation**
- **Automated testing scripts** for each task
- **Idempotent validation** ensuring reliable results
- **Comprehensive error handling** and cleanup procedures
- **Real-time feedback** with detailed success/failure messages

### 📚 **Structured Exam Sets**
- **Multiple exam sets** with unique scenarios and configurations
- **Domain-balanced coverage** following official CKAD curriculum
- **Cross-domain integration** tasks combining multiple concepts
- **Troubleshooting scenarios** for real-world problem-solving

### 🎯 **Exam-Ready Format**
- **Isolated namespaces** for each task to prevent conflicts
- **Clear task descriptions** with specific requirements
- **Complete solutions** for self-assessment
- **Validation scripts** that match exam-style verification

## 🏗️ Architecture

### Task Structure
```
task-XX-[descriptive-name]/
├── prep/                    # Preparation resources
│   ├── namespace.yaml       # Isolated namespace
│   └── [resources].yaml     # Base configurations
├── task/
│   └── task-description.md  # Clear instructions
└── answer/
    ├── solution.yaml        # Complete solution
    ├── solution.md          # Step-by-step explanation
    └── validation.sh        # Automated verification
```

### Domain Coverage
- **Application Environment, Configuration and Security (25%)**: 4 tasks
- **Application Design and Build (20%)**: 3 tasks
- **Application Deployment (20%)**: 3 tasks
- **Services and Networking (20%)**: 3 tasks
- **Application Observability and Maintenance (15%)**: 2 tasks

## 🚀 Getting Started

### Prerequisites
- **Kubernetes cluster** (minikube, kind, or cloud-based)
- **kubectl** configured and working
- **Helm** (for Helm-related tasks)
- **Docker or Podman** (for custom image tasks)

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/ckad-ai.git
   cd ckad-ai
   ```

2. **Start your Kubernetes cluster**
   ```bash
   # For minikube with NetworkPolicy support
   minikube start --cni=calico --driver=docker

   # Verify cluster is ready
   kubectl get nodes
   ```

3. **Choose an exam set**
   ```bash
   # Navigate to exam-0 (first exam set)
   cd ckad-tasks/exam-0

   # Or exam-1 for different scenarios
   cd ckad-tasks/exam-1
   ```

4. **Start with a task**
   ```bash
   # Begin with task-01 (Pod configuration)
   cd task-01-pod-configuration

   # Read the task description
   cat task/task-description.md

   # Create your solution in the prep/ directory
   # Then validate your work
   ./answer/validation.sh
   ```

## 📋 Available Tasks

### Exam Set 0: Core CKAD Concepts
| Task | Topic | Points | Difficulty |
|------|-------|--------|------------|
| 01 | Pod Configuration with ConfigMap | 4 | Simple |
| 02 | ConfigMap Volume Mount | 4 | Simple |
| 03 | Secret Environment Variables | 4 | Simple |
| 04 | Health Probes | 6 | Medium |
| 05 | Resource Limits | 6 | Medium |
| 06 | Deployment Scaling | 6 | Medium |
| 07 | Service Exposure | 6 | Medium |
| 08 | Multi-container Pod | 7 | Medium |
| 09 | Troubleshooting Deployment | 8 | Complex |
| 10 | NetworkPolicy | 7 | Medium |
| 11 | Context Switching | 3 | Simple |
| 12 | RBAC ServiceAccount | 6 | Medium |
| 13 | Custom Image Creation | 7 | Medium |
| 14 | Helm Release | 6 | Medium |
| 15 | Helm Upgrade | 7 | Medium |

### Exam Set 1: Advanced CKAD Concepts
| Task | Topic | Points | Difficulty |
|------|-------|--------|------------|
| 01 | Job Batch Processing | 5 | Simple |
| 02 | CronJob Scheduled Task | 6 | Medium |
| 03 | Persistent Volume | 7 | Medium |
| 04 | Pod SecurityContext | 6 | Medium |
| 05 | ResourceQuota & LimitRange | 7 | Medium |
| 06 | Ingress Exposure | 7 | Medium |
| 07 | PodDisruptionBudget | 6 | Medium |
| 08 | Init Container | 7 | Medium |
| 09 | Log Analysis | 8 | Complex |
| 10 | Custom Resource Definition | 8 | Complex |
| 11 | Advanced ConfigMap Usage | 7 | Medium |
| 12 | Advanced Secret Management | 7 | Medium |
| 13 | Multi-container Ambassador | 8 | Complex |
| 14 | NetworkPolicy Namespace | 7 | Medium |
| 15 | Deployment Rolling Update | 7 | Medium |

## 🎯 Learning Objectives

### Core Skills Developed
- **Kubernetes Resource Management**: Pods, Deployments, Services, ConfigMaps, Secrets
- **Application Configuration**: Environment variables, volume mounts, configuration management
- **Networking**: Services, Ingress, NetworkPolicies, DNS resolution
- **Storage**: PersistentVolumes, PersistentVolumeClaims, volume management
- **Security**: RBAC, ServiceAccounts, SecurityContext, Pod security
- **Troubleshooting**: Log analysis, status investigation, error resolution
- **Package Management**: Helm charts, custom resources, CRDs

### Real-World Scenarios
- **Web Applications**: Nginx deployments, frontend/backend services
- **Microservices**: Multi-container patterns, service communication
- **Data Processing**: Jobs, CronJobs, batch processing workflows
- **Security Hardening**: Network policies, RBAC configuration
- **Monitoring**: Health probes, log analysis, troubleshooting

## 🔧 Exam Structure

### Task Development Standards
1. **Domain Analysis**: Ensure balanced coverage across CKAD domains
2. **Scenario Creation**: Develop realistic, production-like scenarios
3. **Difficulty Progression**: Start simple, progress to complex multi-step tasks
4. **Unique Configurations**: Each task has different namespaces and resource names
5. **Cross-Domain Integration**: Include tasks combining multiple CKAD domains

### Quality Assurance
- [ ] Task completable within 5-10 minutes
- [ ] Clear validation criteria and automated testing
- [ ] Idempotent validation scripts
- [ ] Proper resource isolation (namespace-based)
- [ ] Real-world, production-like scenarios
- [ ] No solution hints in task descriptions

## 🎯 Exam Preparation Features

### Practice Structure
- **Realistic exam scenarios** based on actual CKAD curriculum
- **Time-constrained tasks** matching real exam conditions
- **Progressive difficulty** to build confidence gradually
- **Complete solutions** for self-assessment and learning

### Validation System
- **Automated testing** that mimics exam verification
- **Comprehensive feedback** on task completion
- **Resource cleanup** to prevent cluster pollution
- **Error handling** for common exam pitfalls

## 📊 Exam Quality Standards

### Success Criteria
- **Realistic Difficulty**: Tasks match actual CKAD exam complexity
- **Time Efficiency**: Tasks completable within 5-10 minutes
- **Curriculum Alignment**: All CKAD domains properly covered
- **Real-world Relevance**: Scenarios reflect actual production use

### Quality Standards
- **Unique Exam Sets**: Each exam has completely different scenarios
- **Mixed Difficulty**: Balanced simple → medium → complex progression
- **Production Focus**: Real-world scenarios, not theoretical examples
- **Multiple Approaches**: Tasks with multiple valid solution paths

## 🛠️ Technical Requirements

### Kubernetes Cluster Setup
```bash
# For NetworkPolicy support (required for some tasks)
minikube start --cni=calico --driver=docker

# Verify NetworkPolicy support
kubectl get pods -n kube-system | grep calico
```

### Required Tools
- **kubectl**: Kubernetes command-line tool
- **Helm**: Kubernetes package manager
- **Docker/Podman**: Container runtime (for custom images)
- **Git**: Version control

## 📚 Documentation

### Task Structure
Each task follows a standardized structure:
- **Task Description**: Clear requirements and success criteria
- **Preparation Resources**: Base configurations and broken resources
- **Solution Templates**: Complete working implementations
- **Validation Scripts**: Automated testing and verification

### Best Practices
- **Namespace Isolation**: Each task uses isolated namespaces
- **Resource Cleanup**: Validation scripts clean up all resources
- **Error Handling**: Graceful handling of missing resources
- **Clear Feedback**: Detailed success/failure messages

## 🤝 Contributing

Welcome contributions to improve the CKAD practice exams!

### Contributing Guidelines
1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/new-exam-task`
3. **Follow exam task structure standards**
4. **Include comprehensive validation scripts**
5. **Test thoroughly** with different Kubernetes versions
6. **Submit a pull request**

### Development Standards
- **Exam Quality**: Follow the established task creation guidelines
- **Validation Scripts**: Ensure idempotent and comprehensive testing
- **Documentation**: Clear task descriptions and solution explanations
- **Testing**: Verify with multiple Kubernetes distributions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **CNCF**: For the CKAD certification program
- **Kubernetes Community**: For the excellent documentation and examples
- **Open Source Contributors**: For the tools and libraries that make this possible

## 📞 Support

- **Issues**: Report bugs or request features via GitHub Issues
- **Discussions**: Join community discussions for help and tips
- **Documentation**: Check the task descriptions for detailed guidance

---

**Ready to ace your CKAD exam? Start with your first practice exam and build your confidence! 🚀**