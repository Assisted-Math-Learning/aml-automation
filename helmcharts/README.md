# AML Helm Charts

This directory hosts the Helm charts required for deploying AML infrastructure components. These charts are crafted to work in unison for setting up a comprehensive AML environment.

## Prerequisites

Ensure the following are in place before installing these Helm charts:

1. A running Kubernetes cluster
2. Helm version 3.x or higher installed
3. `kubectl` configured with the appropriate context
4. Necessary namespaces created
5. Required secrets and configurations available

## Installation Instructions

The charts must be installed in the following order to ensure proper dependency resolution:

1. **cert-manager** (Required for SSL/TLS certificates)
2. **kong** (API Gateway and Ingress Controller)
3. **kong-ingress-routes** (Requires kong to be installed)
4. **postgresql** (Required database for other services)
5. **postgresql-migration** (Requires postgresql to be running)
6. **letsencrypt-ssl** (Requires cert-manager)
7. **api-service** (Requires postgresql and kong)
8. **jobs-service** (Requires postgresql and kong)

Prior to installation, update the respective `values.yaml` files with the following:

**In `kong-ingress-routes/values.yaml`**

- `domain`: Set to match the sslip (e.g., `example.sslip.io`)

**In `kong/values.yaml`**
- `service.beta.kubernetes.io/aws-load-balancer-type`: Change to `nlb` (e.g., `nlb`)
- `service.beta.kubernetes.io/aws-load-balancer-scheme`: Set to `internet-facing` (e.g., `internet-facing`)
- `service.beta.kubernetes.io/aws-load-balancer-eip-allocations`: Match with the sslip (e.g., `eipalloc-12345678`)
- `service.beta.kubernetes.io/aws-load-balancer-subnets`: Set to the VPC subnets (e.g., `subnet-12345678,subnet-87654321`)

**In `letsencrypt-ssl/values.yaml`**
- domain_admin_email: "<admin@example.com>" (e.g., `admin@example.com`)
- domain: &domain "<example.com>" (e.g., `example.com`)

**Install each chart**
   ```bash
   # Install cert-manager
   helm install cert-manager ./cert-manager -n aml --create-namespace

   # Install PostgreSQL
   helm install postgresql ./postgresql -n aml --create-namespace

   # Install other services
   helm install api-service ./api-service -n aml
   helm install jobs-service ./jobs-service -n aml
   # Continue with other services as needed
   ```

## Configuration

Each chart comes with its own `values.yaml` file for configuration. Common parameters include:

- Resource limits and requests
- Number of replicas
- Environment variables
- Service settings
- Ingress configurations

To customize a chart during installation:

```bash
helm install [RELEASE_NAME] ./[CHART_NAME] -f custom-values.yaml
```

## Upgrading

Follow these steps to upgrade an existing installation:

```bash
helm upgrade [RELEASE_NAME] ./[CHART_NAME] -f values.yaml
```

## Uninstallation

To remove the charts from your environment:

```bash
helm uninstall [RELEASE_NAME] -n [NAMESPACE]
```

## Troubleshooting

Here are common troubleshooting steps:

1. Check the status of pods:
   ```bash
   kubectl get pods -n [NAMESPACE]
   ```

2. View logs for a specific pod:
   ```bash
   kubectl logs [POD_NAME] -n [NAMESPACE]
   ```

3. List Helm releases:
   ```bash
   helm list -n [NAMESPACE]
   ```