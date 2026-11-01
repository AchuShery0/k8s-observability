# Infrastructure Observability Stack — Kubernetes Monitoring

> Personal Project | Aug 2025 – Oct 2025

## What This Does

Full observability stack deployed on a 5-node kubeadm Kubernetes cluster:
- **Prometheus + Grafana** — metrics collection and dashboards
- **EFK Stack** (Elasticsearch, Fluentd, Kibana) — centralised log aggregation
- **Alertmanager** — alerting on error-rate spikes
- **HPA** — Horizontal Pod Autoscaler for automatic scaling

## Architecture

```
  Microservices (8 services)
        │
        ├──► Fluentd ──► Elasticsearch ──► Kibana  (logs)
        │
        └──► Prometheus ──► Grafana         (metrics)
                  │
                  └──► Alertmanager ──► Slack / Email  (alerts)

  Under load:
  HPA monitors CPU/memory ──► scales pods 2 → 8 automatically
```

**Stack:** Kubernetes (kubeadm, 5 nodes) · Helm · Prometheus · Grafana · Elasticsearch · Fluentd · Kibana · Alertmanager · HPA · Python · Bash

## Key Results

| Metric | Before | After |
|--------|--------|-------|
| Root-cause identification time | ~30 min | ~10 min |
| Pod count under peak load | 2 | 8 (auto-scaled) |
| Response time under peak load | Degraded | <300ms maintained |
| Dashboards | None | 12 Grafana dashboards |

## Project Structure

```
k8s-observability/
├── prometheus/
│   ├── values.yaml             # kube-prometheus-stack Helm values
│   └── alertmanager-rules.yaml # Custom alerting rules
├── grafana/
│   └── dashboards/
│       └── cluster-overview.json  # Exported Grafana dashboard
├── efk/
│   ├── elasticsearch.yaml      # Elasticsearch StatefulSet
│   ├── fluentd-configmap.yaml  # Fluentd log routing config
│   └── kibana.yaml             # Kibana Deployment + Service
├── hpa/
│   └── hpa.yaml                # HorizontalPodAutoscaler for 3 workloads
└── scripts/
    ├── deploy-alerts.sh        # Bash: deploy Alertmanager rules
    └── metrics-report.py       # Python: weekly Prometheus report
```

## How to Deploy

### 1. Install Prometheus + Grafana
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -f prometheus/values.yaml \
  --namespace monitoring \
  --create-namespace
```

### 2. Deploy Alertmanager rules
```bash
chmod +x scripts/deploy-alerts.sh
./scripts/deploy-alerts.sh
```

### 3. Deploy EFK Stack
```bash
kubectl apply -f efk/elasticsearch.yaml
kubectl apply -f efk/fluentd-configmap.yaml
kubectl apply -f efk/kibana.yaml
```

### 4. Apply HPA
```bash
kubectl apply -f hpa/hpa.yaml
```

### 5. Access dashboards
```bash
# Grafana
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring

# Kibana
kubectl port-forward svc/kibana 5601:5601 -n logging
```

### 6. Generate weekly metrics report
```bash
python3 scripts/metrics-report.py --prometheus-url http://localhost:9090 --output report.html
```
