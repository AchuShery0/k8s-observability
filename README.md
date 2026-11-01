# Kubernetes Observability Lab

A hands-on Kubernetes project focused on cluster monitoring, metrics collection, Grafana dashboards, and Horizontal Pod Autoscaling (HPA).

## Project Overview

This project uses a local **Minikube Kubernetes cluster** to practise Kubernetes observability and workload scaling.

The validated implementation includes:

- **Prometheus** – collects Kubernetes and cluster metrics.
- **Grafana** – visualises node, namespace, and workload metrics.
- **Metrics Server** – provides resource metrics for Kubernetes workloads.
- **Horizontal Pod Autoscaler (HPA)** – scales a frontend deployment based on CPU utilisation.
- **Helm** – deploys the Prometheus and Grafana monitoring stack.

## Architecture

```text
                 Kubernetes Cluster
                      (Minikube)
                          |
          +---------------+---------------+
          |                               |
    Frontend Workload                Monitoring
          |                               |
    HPA (CPU-based)                  Prometheus
          |                               |
    Scale Replicas                    Grafana
                                          |
                                      Dashboards
```

## Technology Stack

- Kubernetes
- Minikube
- Docker
- Helm
- Prometheus
- Grafana
- Metrics Server
- YAML
- Linux

## Validated Implementation

The following functionality was tested in a local Minikube environment:

| Component | Validation |
|---|---|
| Minikube cluster | Running single-node cluster |
| Prometheus | 14 active scrape targets shown as UP |
| Grafana | Kubernetes workload and resource dashboards viewed |
| Metrics Server | Resource metrics available |
| Frontend deployment | Nginx pods deployed in the `prod` namespace |
| HPA scale-up | Scaled from 2 to 3 and then 5 replicas during CPU load testing |
| HPA scale-down | Returned from 5 to 2 replicas after load was removed |

**Note:** These are local lab results, not production-cluster benchmarks.

## Repository Structure

```text
k8s-observability/
├── efk/
│   ├── elasticsearch.yaml
│   ├── fluentd-configmap.yaml
│   ├── fluentd-daemonset.yaml
│   ├── fluentd-rbac.yaml
│   ├── kibana.yaml
│   └── logging-namespace.yaml
│
├── hpa/
│   └── hpa.yaml
│
├── prometheus/
│   ├── values.yaml
│   └── alertmanager-rules.yaml
│
├── scripts/
│
└── README.md
```

## Local Environment

Tested with:

- Ubuntu 26.04
- Minikube 1.39.0
- Kubernetes 1.37.0
- Helm 4.3.1
- Docker 29.1.3

## Running the Monitoring Stack

### 1. Start Minikube

```bash
minikube start --driver=docker
```

### 2. Enable Metrics Server

```bash
minikube addons enable metrics-server
```

### 3. Create the monitoring namespace

```bash
minikube kubectl -- create namespace monitoring
```

### 4. Configure Grafana credentials

Create a Kubernetes Secret named `grafana-admin` in the `monitoring` namespace before installing the Helm chart.

Do not commit passwords or other credentials to GitHub.

### 5. Add the Prometheus Community Helm repository

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 6. Install the monitoring stack

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f prometheus/values.yaml \
  --wait --timeout 10m
```

### 7. Verify monitoring pods

```bash
minikube kubectl -- get pods -n monitoring
```

## HPA Testing

The frontend deployment was tested in the `prod` namespace using Nginx.

### 1. Configure autoscaling

```bash
minikube kubectl -- autoscale deployment frontend \
  --namespace prod \
  --cpu-percent=50 \
  --min=2 \
  --max=5
```

### 2. Check HPA status

```bash
minikube kubectl -- get hpa -n prod
```

### 3. Check frontend pods

```bash
minikube kubectl -- get pods -n prod
```

During CPU load testing, the frontend deployment scaled from 2 to 3 and then 5 replicas. After the load was removed, it returned to 2 replicas.

## Accessing Monitoring Dashboards

Grafana can be accessed locally using port forwarding:

```bash
minikube kubectl -- port-forward -n monitoring svc/monitoring-grafana 3000:80
```

Open:

```text
http://localhost:3000
```

Prometheus can be accessed locally using:

```bash
minikube kubectl -- port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```

Open:

```text
http://localhost:9090
```

## Current Scope and Future Improvements

The following repository components are not yet fully validated as part of the local implementation:

- Elasticsearch, Fluentd, and Kibana logging deployment.
- Custom alert-rule behaviour and alert delivery.
- Additional application workloads and their HPA configurations.
- Multi-node Kubernetes deployment.
- Production-scale performance testing.

## Learning Outcomes

- Deploying a Kubernetes monitoring stack using Helm.
- Understanding Prometheus scrape targets and metrics collection.
- Exploring Kubernetes metrics in Grafana.
- Monitoring CPU and memory utilisation.
- Configuring and testing Horizontal Pod Autoscaling.
- Troubleshooting Kubernetes workloads and monitoring components.

---

**Project Status:** Local monitoring and HPA functionality tested on Minikube. Additional components remain under development.
