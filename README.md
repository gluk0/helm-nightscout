# helm-nightscout

Charts for cgm-remote-monitor (nightscout) and a MongoDB backend.

## Installing the Chart

To install the chart with the release name `my-nightscout`, this release name can be updated to your preference and used by helm to anchor changes to a given set of Kubernetes objects.:

```bash
helm install my-nightscout ./helm
```

Or with custom values:

```bash
helm install my-nightscout ./helm -f user-values.yaml
```

## Required Configuration

Before installing, you **must** configure:

1. **MongoDB Connection String** (`nightscout.mongodbUri`)
2. **API Secret** (`nightscout.apiSecret`)

### Example Values File

Create a `my-values.yaml` file:

```yaml
nightscout:
  mongodbUri: "mongodb://username:password@mongodb-host:27017/nightscout"
  apiSecret: "your-secret-min-12-chars"
  baseUrl: "https://nightscout.example.com"
  customTitle: "My Nightscout"
  timezone: "America/New_York"

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: nightscout.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: nightscout-tls
      hosts:
        - nightscout.example.com
```

## Configuration

The following table lists the configurable parameters of the Nightscout chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `nightscout/cgm-remote-monitor` |
| `image.tag` | Image tag | `""` (uses appVersion) |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `1337` |
| `nightscout.mongodbUri` | MongoDB connection string | `""` (required) |
| `nightscout.apiSecret` | API secret for Nightscout | `""` (required) |
| `nightscout.baseUrl` | Base URL for Nightscout | `""` |
| `nightscout.customTitle` | Custom title | `"Nightscout"` |
| `nightscout.timezone` | Timezone | `""` |
| `nightscout.theme` | Theme (default, colors, colorblindfriendly) | `default` |
| `nightscout.units` | Units (mg/dl or mmol) | `mg/dl` |
| `nightscout.timeFormat` | Time format (12 or 24) | `24` |
| `ingress.enabled` | Enable ingress | `false` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `250m` |
| `resources.requests.memory` | Memory request | `256Mi` |

## Upgrading

To upgrade the release:

```bash
helm upgrade my-nightscout ./helm -f my-values.yaml
```

## Uninstalling

To uninstall/delete the `my-nightscout` deployment:

```bash
helm uninstall my-nightscout
```

## MongoDB Setup

This chart does not include MongoDB by default. You need to provide an external MongoDB instance. Options:

1. **External MongoDB service** (recommended for production)
2. **MongoDB in Kubernetes** using a separate Helm chart like Bitnami MongoDB:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb \
  --set auth.rootPassword=secretpassword \
  --set auth.username=nightscout \
  --set auth.password=nightscoutpass \
  --set auth.database=nightscout
```

Then use this connection string:

```yaml
nightscout:
  mongodbUri: "mongodb://nightscout:nightscoutpass@mongodb:27017/nightscout"
```
