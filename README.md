# Azure-DevOps End-to-End CI/CD Implementation

![Entire CI/CD Implementation - Using Azure DevOps](Entire%20CICD%20Implementation%20-%20Using%20Azure%20Devops.png)

## About the Application :

Implementing Continuous Integration (CI)  
A front-end web app in Python which lets you vote between two options  
A Redis which collects new votes  
A .NET worker which consumes votes and stores them  
A Postgres database backed by a Docker volume  
A Node.js web app which shows the results of the voting in real time

![Application Architecture](architecture.excalidraw.png)

# 🚀 CI & CD Architecture Overview

This project follows a complete **End-to-End DevOps workflow** using Azure DevOps, ACR, AKS, and Argo CD.  
The sections below explain — in very simple terms — what services are involved in **Continuous Integration (CI)** and **Continuous Deployment (CD)**.

---

## 🔧 Continuous Integration (CI) — Build & Prepare the Application

Continuous Integration (CI) is the phase where your application code is **built**, **packaged**, and **stored** as a Docker image.  
The following services are used during the CI stage:

---

### 1. Azure Pipelines (CI Pipeline Orchestration)

- Controls and runs the CI process.  
- Defines the stages such as **Build**, **Push**, and **Tag Update**.  
- Handles triggers (for example, only build when a specific microservice changes).

---

### 2. Azure Repos (Source Code Storage)

- Stores the **Voting Application source code** after migrating from GitHub.  
- Acts as the single source of truth for the CI pipeline.

---

### 3. Azure Container Registry — ACR (Artifact Storage)

- Stores the **built Docker images** for:
  - Python Frontend  
  - Node.js Results App  
  - .NET Worker  
- Works as a secure, private alternative to Docker Hub.

---

### 4. Azure VM + Self-Hosted Agent (Job Execution Engine)

- A Virtual Machine created in Azure is connected as a **Self-Hosted Agent**.  
- Executes the CI tasks like Docker build, Docker push, and YAML tag updates.

---

### 5. Azure DevOps Platform (Overall CI Engine)

- The central platform hosting Azure Pipelines and Azure Repos.  
- Manages agent pools, project settings, pipelines, and artifacts.

---

## 📝 Shell Script

**Purpose:**  
The shell script updates the image tag in the deployment YAML file with the latest image ID from the Azure Container Registry (ACR).  
It is executed as part of the CI pipeline to ensure that the most recent image version is deployed.

---

# 🚢 Continuous Deployment (CD) — Release & Deliver the Application

Continuous Deployment (CD) ensures that whenever a new Docker image is built, it is **automatically delivered** to the Azure Kubernetes Service (AKS) using GitOps principles.

The following services handle the CD stage:

---

### 1. Argo CD (Deployment Engine — Implements GitOps)

- Continuously monitors Kubernetes manifests stored in Git.  
- Automatically syncs the newest changes to the AKS cluster.  
- Ensures the live environment always matches what is defined in Git.

---

### 2. Azure Kubernetes Service — AKS (Target Deployment Platform)

- The Kubernetes cluster where your microservices run.  
- Hosts Pods, Deployments, Services, and Ingress configurations.

---

### 3. Azure Repos (Configuration Hub — Manifests Storage)

- Stores Kubernetes YAML files such as:
  - `deployment.yaml`
  - `service.yaml`
  - `ingress.yaml`
- Argo CD reads these files and applies them to AKS.

---

### 4. Azure Pipelines (CD Orchestration / Manifest Update Trigger)

- Automatically triggered after a successful CI pipeline.  
- Updates the Kubernetes manifests with the latest Docker image tag.  
- Commits the updated files → Argo CD deploys the new version.

---

### 5. Azure Container Registry — ACR (Image Source for Deployment)

- Stores versioned Docker images built during the CI process.  
- AKS pulls the images directly from ACR during deployment.

---


## Footer  
© 2025 YourName or Organization  
