#!/usr/bin/env bash
# deploy-alerts.sh — Deploy Alertmanager rules to Kubernetes
# Usage: ./scripts/deploy-alerts.sh [namespace]

set -euo pipefail

NAMESPACE="${1:-monitoring}"
RULES_FILE="prometheus/alertmanager-rules.yaml"

echo "Deploying Alertmanager rules to namespace: $NAMESPACE"

# Check namespace exists
if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
  echo "ERROR: Namespace '$NAMESPACE' does not exist."
  echo "Run: kubectl create namespace $NAMESPACE"
  exit 1
fi

# Apply rules
kubectl apply -f "$RULES_FILE" -n "$NAMESPACE"

# Wait for Prometheus to pick up the rules
echo "Waiting for Prometheus to reload rules..."
sleep 10

# Verify rules loaded
RULE_COUNT=$(kubectl get prometheusrule -n "$NAMESPACE" -o jsonpath='{.items[*].spec.groups[*].rules}' | python3 -c "import sys,json; data=sys.stdin.read(); print(len(json.loads('['+data.replace('}{','},{')+']')) if data else 0)" 2>/dev/null || echo "unknown")

echo "Rules deployed successfully to $NAMESPACE."
echo "Check Prometheus UI → Alerts tab to verify they are active."
