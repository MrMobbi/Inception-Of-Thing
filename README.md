# Inception of Things (IoT)

## Overview
This project is an introduction to Kubernetes using K3s and K3d, combined with Vagrant for virtual machine management and Argo CD for continuous deployment.

It is divided into three main parts:
- Multi-node Kubernetes cluster (K3s + Vagrant)
- Application deployment with Ingress
- GitOps workflow with Argo CD

---

## Project Structure

```
.
├── docs/              # Subject and requirements
├── p1/                # K3s cluster (2 nodes with Vagrant)
├── p2/                # K3s + 3 applications + Ingress
├── p3/                # K3d + Argo CD (CI/CD)
└── README.md
```

### Detailed Structure

---

### p1/ – K3s & Vagrant (Cluster Setup)

```
p1/
├── Makefile
├── Vagrantfile
└── scripts/
    ├── common.sh
    ├── server.sh
    └── worker.sh
```

Description:
- Creates 2 virtual machines using Vagrant  
- Installs K3s:
  - Server node (controller)  
  - Worker node (agent)  

Scripts:
- common.sh → shared setup  
- server.sh → installs K3s server  
- worker.sh → joins worker to cluster  

---

### p2/ – Applications & Ingress

```
p2/
├── Makefile
├── Vagrantfile
├── scripts/
│   ├── common.sh
│   └── server.sh
└── configs/
    ├── app1.yaml
    ├── app2.yaml
    ├── app3.yaml
    ├── ingress.yaml
    └── hosts
```

Description:
- Single-node K3s cluster  
- Deploys 3 web applications  
- Uses Ingress for routing  

Routing logic:
- app1.com → app1  
- app2.com → app2 (3 replicas)  
- default → app3  

Configs:
- app*.yaml → deployments and services  
- ingress.yaml → routing rules  
- hosts → local DNS mapping  

---

### p3/ – K3d & Argo CD (CI/CD)

```
p3/
├── Makefile
├── scripts/
│   ├── install.sh
│   ├── common.sh
│   ├── argocd.sh
│   └── app.sh
├── app/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── argocd/
│   ├── application.yaml
│   └── ingress.yaml
├── config/
└── secret/
    ├── certificate.pem
    └── privatekey.pem
```

Description:
- Uses K3d (Docker-based Kubernetes)  
- Deploys Argo CD  
- Implements a GitOps workflow  

Key components:

Application (app/):
- Kubernetes manifests for the deployed app  
- Supports multiple versions (v1, v2)  

Argo CD (argocd/):
- application.yaml links a GitHub repository to the cluster  
- Automatically synchronizes changes  

Secrets (secret/):
- TLS certificates for secure access  

Scripts:
- install.sh → installs dependencies (Docker, K3d, kubectl)  
- argocd.sh → deploys Argo CD  
- app.sh → deploys the application  
- common.sh → shared utilities  

---

## How to Run

### Part 1
```
cd p1
make
```

### Part 2
```
cd p2
make
```

### Part 3
```
cd p3
make
```

---

## Access

### Part 2 (Ingress)

Add the following to /etc/hosts:
```
192.168.56.110 app1.com
192.168.56.110 app2.com
192.168.56.110 app3.com
```

Then open in a browser:
- http://app1.com  
- http://app2.com  
- http://app3.com  

---

## CI/CD Workflow (Part 3)

1. Update the application version in:
   p3/app/deployment.yaml  

2. Push changes to the Git repository  

3. Argo CD detects the modification  

4. The application is automatically redeployed  

---

## Technologies Used

- Vagrant  
- K3s  
- K3d  
- Docker  
- Kubernetes  
- Argo CD  

---

## Notes

- All environments are automated using Makefiles and scripts  
- Minimal resources are used for virtual machines  
- The project is designed to be reproducible  

