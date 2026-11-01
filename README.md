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

## Project Screenshots

### Prometheus Targets

The screenshots show the Prometheus scrape targets observed during local validation.

![Prometheus Targets - First View](prometheus-targets-1.png)

![Prometheus Targets - Second View](prometheus-targets-2.png)

### Grafana Dashboard

The Grafana dashboard shows Kubernetes workload resource usage, including CPU and memory metrics.

![Grafana Kubernetes Dashboard](grafana-dashboard.png)

### Horizontal Pod Autoscaler

The screenshot shows the frontend deployment's autoscaler status after CPU load testing.

![HPA Status](hpa-status.png)

## Repository Structure

```text
k8s-observability/
├── efk/
│   ├── elasticsearch.yaml
│   ├── fluentd-configmap.yaml
│   ├── fluentd-daemonset.yaml
│   ├── fluentd-rbac.yaml
│   ├── kib
