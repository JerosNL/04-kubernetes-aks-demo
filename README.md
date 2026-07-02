# Kubernetes AKS Demo

## What this is

A Python calculator app deployed to Azure Kubernetes Service (AKS) through a fully automated Azure DevOps pipeline. This is my fourth hands-on DevOps project, combining Terraform, Docker and Kubernetes into a single end-to-end pipeline.

## What the pipeline does

```
Provision AKS with Terraform → Build and push Docker image → Deploy to AKS → Destroy cluster
```

The entire AKS cluster exists only for the duration of the pipeline run — roughly 10-15 minutes. Terraform creates it at the start and destroys it at the end, keeping costs to a few cents per run.

## Pipeline stages

**Provision** — Terraform provisions a resource group and AKS cluster in Azure West Europe. State is stored remotely in Azure Blob Storage so the pipeline always knows what exists.

**Build** — Docker builds the calculator image, runs tests inside the build, and pushes two tags to GitHub Container Registry: a unique build ID tag and `latest`.

**Deploy** — kubectl applies the Kubernetes manifests to the cluster. A rollout status check confirms the pod is running before the stage completes.

**Destroy** — Terraform destroys all resources regardless of whether the Deploy stage succeeded or failed, using `condition: always()`. This guarantees no orphaned resources and no unexpected costs.

## What I learned

- Kubernetes uses a declarative model — you describe the desired state in manifests and the control plane continuously works to match reality to that description
- A Deployment manages pod lifecycle — if a pod crashes Kubernetes automatically restarts it without any manual intervention
- A Service provides a stable network endpoint in front of pods — pods come and go with changing IP addresses but the Service address stays constant
- `condition: always()` on the Destroy stage is critical — it ensures the cluster is destroyed even if earlier stages fail, preventing orphaned resources and unexpected costs
- AKS worker nodes are the main cost driver in Kubernetes — destroying them after each demo run keeps costs near zero
- The AKS cluster uses a SystemAssigned managed identity so it can interact with Azure services like load balancers without storing credentials anywhere
- `ErrImagePull` means the cluster cannot pull the container image — in this case because the GitHub Container Registry image was private. In production this is solved with a Kubernetes image pull secret
- The `kubectl rollout status` command is the correct way to wait for a deployment to complete in a pipeline — it blocks until all pods are healthy or times out

## Tech used

- Terraform
- Azure Kubernetes Service (AKS)
- Docker
- GitHub Container Registry (ghcr.io)
- kubectl
- Azure DevOps Pipelines
- Self-hosted Windows agent

## Project structure

```
├── terraform/          # AKS cluster provisioning
├── k8s/                # Kubernetes manifests
│   ├── deployment.yaml # Pod specification and replica count
│   └── service.yaml    # Load balancer and network endpoint
├── src/                # Calculator application
├── tests/              # pytest unit tests
└── Dockerfile          # Container image definition
```

## Screenshots

![Pipeline summary](screenshots/pipeline-summary.jpg)
![Deploy stage log](screenshots/deploy-stage-log.jpg)
![Destroy stage log](screenshots/destroy-stage-log.jpg)