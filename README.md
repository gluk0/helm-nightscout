# Nightscout Helm Chart

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 15.0.3](https://img.shields.io/badge/AppVersion-15.0.3-informational?style=flat-square)

A Helm chart for Nightscout - Web-based CGM (Continuous Glucose Monitor) to visualize and monitor glucose data in real-time

## Introduction

This Helm chart deploys [Nightscout](https://github.com/nightscout/cgm-remote-monitor), an open-source web application for visualizing and monitoring Continuous Glucose Monitor (CGM) data. Nightscout enables people with diabetes and their caregivers to remotely view glucose data in real-time.

## Features

- 🔒 **Secure by Default** - Security contexts, optional NetworkPolicy, and secret management
- 📊 **Comprehensive Configuration** - All Nightscout environment variables exposed
- 🚀 **Production Ready** - HPA, PDB, probes, and resource limits
- 🔌 **Plugin Support** - Full support for all Nightscout plugins
- 🔗 **Bridge Support** - Dexcom Share and MiniMed CareLink integration
- 📈 **Observable** - Health checks and monitoring endpoints
- 🛡️ **High Availability** - Horizontal scaling and disruption budgets

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8+
- MongoDB instance (external or via subchart)
- PV provisioner support in the underlying infrastructure (optional)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mongodb | ^15.0.0 |

## Installation

### Quick Start

```bash
# Add the Helm repository (if published)
helm repo add nightscout https://YOUR_REPO_URL
helm repo update

# Install with minimal configuration
helm install my-nightscout nightscout/nightscout \
  --set nightscout.mongodbUri="mongodb://user:pass@host:27017/nightscout" \
  --set nightscout.apiSecret="your-secret-min-12-chars"
```

### Install from Source

```bash
git clone https://github.com/YOUR_ORG/helm-nightscout.git
cd helm-nightscout

helm install my-nightscout . -f values.yaml
```

## Configuration

### Required Configuration

Before installing, you **must** configure:

1. **MongoDB Connection String** - Connection to your MongoDB instance
2. **API Secret** - At least 12 characters for securing your Nightscout instance

### Example Values Files

#### Basic Configuration

```yaml
nightscout:
  mongodbUri: "mongodb://username:password@mongodb-host:27017/nightscout"
  apiSecret: "your-secret-min-12-chars"
  baseUrl: "https://nightscout.example.com"

  display:
    customTitle: "My Nightscout"
    timezone: "America/New_York"
    units: "mg/dl"
    theme: "colors"

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

#### Production Configuration with High Availability

```yaml
replicaCount: 2

nightscout:
  existingSecret: "nightscout-secrets"
  baseUrl: "https://nightscout.example.com"

  enable:
    - careportal
    - boluscalc
    - iob
    - cob
    - basal
    - ar2

  auth:
    defaultRoles: "denied"  # Require authentication

  display:
    customTitle: "Production Nightscout"
    timezone: "America/New_York"
    units: "mg/dl"

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5
  targetCPUUtilizationPercentage: 70

podDisruptionBudget:
  enabled: true
  maxUnavailable: 1

networkPolicy:
  enabled: true
  ingress:
    namespaceSelector:
      matchLabels:
        name: ingress-nginx

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
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

#### Configuration with Dexcom Share Bridge

```yaml
nightscout:
  mongodbUri: "mongodb://user:pass@host:27017/nightscout"
  apiSecret: "your-secret-min-12-chars"

  enable:
    - careportal
    - bridge
    - iob
    - cob

  bridge:
    enabled: true
    userName: "dexcom-username"
    password: "dexcom-password"
    server: "US"  # or "EU"
```

## Parameters

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `5` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nightscout/cgm-remote-monitor"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"nightscout.example.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/api/v1/status"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| mongodb.architecture | string | `"standalone"` |  |
| mongodb.auth.database | string | `"nightscout"` |  |
| mongodb.auth.database | string | `"nightscout"` |  |
| mongodb.auth.enabled | bool | `true` |  |
| mongodb.auth.enabled | bool | `true` |  |
| mongodb.auth.password | string | `""` |  |
| mongodb.auth.rootPassword | string | `""` |  |
| mongodb.auth.username | string | `"nightscout"` |  |
| mongodb.auth.username | string | `"nightscout"` |  |
| mongodb.enabled | bool | `true` |  |
| mongodb.enabled | bool | `false` |  |
| mongodb.persistence.enabled | bool | `true` |  |
| mongodb.persistence.enabled | bool | `true` |  |
| mongodb.persistence.size | string | `"8Gi"` |  |
| mongodb.persistence.size | string | `"8Gi"` |  |
| mongodb.resources.limits.cpu | string | `"500m"` |  |
| mongodb.resources.limits.memory | string | `"512Mi"` |  |
| mongodb.resources.requests.cpu | string | `"250m"` |  |
| mongodb.resources.requests.memory | string | `"256Mi"` |  |
| mongodb.service.ports.mongodb | int | `27017` |  |
| mongodb.service.type | string | `"ClusterIP"` |  |
| nameOverride | string | `""` |  |
| networkPolicy.egress.allowExternal | bool | `true` |  |
| networkPolicy.egress.enabled | bool | `true` |  |
| networkPolicy.egress.extraRules | list | `[]` |  |
| networkPolicy.egress.mongodbNamespaceSelector | object | `{}` |  |
| networkPolicy.egress.mongodbPodSelector | object | `{}` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.ingress.enabled | bool | `true` |  |
| networkPolicy.ingress.extraRules | list | `[]` |  |
| networkPolicy.ingress.namespaceSelector | object | `{}` |  |
| networkPolicy.ingress.podSelector | object | `{}` |  |
| nightscout.alarms.high.enabled | string | `"on"` |  |
| nightscout.alarms.high.snoozeMins | string | `"30 60 90 120"` |  |
| nightscout.alarms.low.enabled | string | `"on"` |  |
| nightscout.alarms.low.snoozeMins | string | `"15 30 45 60"` |  |
| nightscout.alarms.target.bottom | int | `80` |  |
| nightscout.alarms.target.top | int | `180` |  |
| nightscout.alarms.timeago.urgent.enabled | string | `"on"` |  |
| nightscout.alarms.timeago.urgent.mins | int | `30` |  |
| nightscout.alarms.timeago.warn.enabled | string | `"on"` |  |
| nightscout.alarms.timeago.warn.mins | int | `15` |  |
| nightscout.alarms.types | string | `"simple"` |  |
| nightscout.alarms.urgent.high | int | `260` |  |
| nightscout.alarms.urgent.low | int | `55` |  |
| nightscout.alarms.urgent.snoozeMins | string | `"30 60 90 120"` |  |
| nightscout.alarms.urgentHigh.enabled | string | `"on"` |  |
| nightscout.alarms.urgentHigh.snoozeMins | string | `"30 60 90 120"` |  |
| nightscout.alarms.urgentLow.enabled | string | `"on"` |  |
| nightscout.alarms.urgentLow.snoozeMins | string | `"15 30 45"` |  |
| nightscout.alarms.warn.snoozeMins | string | `"30 60 90 120"` |  |
| nightscout.apiSecret | string | `""` |  |
| nightscout.auth.defaultRoles | string | `"readable"` |  |
| nightscout.auth.treatmentsAuth | string | `"on"` |  |
| nightscout.baseUrl | string | `""` |  |
| nightscout.bridge.enabled | bool | `false` |  |
| nightscout.bridge.password | string | `""` |  |
| nightscout.bridge.server | string | `"US"` |  |
| nightscout.bridge.userName | string | `""` |  |
| nightscout.collections.activity | string | `"activity"` |  |
| nightscout.collections.devicestatus | string | `"devicestatus"` |  |
| nightscout.collections.entries | string | `"entries"` |  |
| nightscout.collections.food | string | `"food"` |  |
| nightscout.collections.profile | string | `"profile"` |  |
| nightscout.collections.treatments | string | `"treatments"` |  |
| nightscout.disable | list | `[]` |  |
| nightscout.display.customTitle | string | `"Nightscout"` |  |
| nightscout.display.dayEnd | string | `"21.0"` |  |
| nightscout.display.dayStart | string | `"7.0"` |  |
| nightscout.display.editMode | string | `"on"` |  |
| nightscout.display.language | string | `"en"` |  |
| nightscout.display.nightMode | string | `"off"` |  |
| nightscout.display.scaleY | string | `"log"` |  |
| nightscout.display.showRawBg | string | `"never"` |  |
| nightscout.display.theme | string | `"default"` |  |
| nightscout.display.timeFormat | int | `24` |  |
| nightscout.display.timezone | string | `""` |  |
| nightscout.display.units | string | `"mg/dl"` |  |
| nightscout.enable[0] | string | `"careportal"` |  |
| nightscout.enable[10] | string | `"bage"` |  |
| nightscout.enable[11] | string | `"basal"` |  |
| nightscout.enable[12] | string | `"ar2"` |  |
| nightscout.enable[13] | string | `"rawbg"` |  |
| nightscout.enable[14] | string | `"pushover"` |  |
| nightscout.enable[15] | string | `"treatmentnotify"` |  |
| nightscout.enable[16] | string | `"bridge"` |  |
| nightscout.enable[17] | string | `"mmconnect"` |  |
| nightscout.enable[18] | string | `"pump"` |  |
| nightscout.enable[19] | string | `"openaps"` |  |
| nightscout.enable[1] | string | `"boluscalc"` |  |
| nightscout.enable[20] | string | `"loop"` |  |
| nightscout.enable[21] | string | `"override"` |  |
| nightscout.enable[22] | string | `"xdripjs"` |  |
| nightscout.enable[23] | string | `"alexa"` |  |
| nightscout.enable[24] | string | `"googlehome"` |  |
| nightscout.enable[25] | string | `"speech"` |  |
| nightscout.enable[2] | string | `"food"` |  |
| nightscout.enable[3] | string | `"rawbg"` |  |
| nightscout.enable[4] | string | `"iob"` |  |
| nightscout.enable[5] | string | `"cob"` |  |
| nightscout.enable[6] | string | `"bwp"` |  |
| nightscout.enable[7] | string | `"cage"` |  |
| nightscout.enable[8] | string | `"sage"` |  |
| nightscout.enable[9] | string | `"iage"` |  |
| nightscout.existingSecret | string | `""` |  |
| nightscout.existingSecretKeys.apiSecret | string | `"api-secret"` |  |
| nightscout.existingSecretKeys.mongodbUri | string | `"mongodb-uri"` |  |
| nightscout.extraEnv | list | `[]` |  |
| nightscout.mmconnect.enabled | bool | `false` |  |
| nightscout.mmconnect.password | string | `""` |  |
| nightscout.mmconnect.server | string | `"US"` |  |
| nightscout.mmconnect.userName | string | `""` |  |
| nightscout.mongodbUri | string | `""` |  |
| nightscout.plugins.bolusRenderOver | int | `1` |  |
| nightscout.plugins.devicestatus.advanced | bool | `false` |  |
| nightscout.plugins.errorcodes.info | string | `"1 2 3 4 5 6 7 8"` |  |
| nightscout.plugins.errorcodes.urgent | string | `"9 10"` |  |
| nightscout.plugins.errorcodes.warn | string | `"off"` |  |
| nightscout.plugins.showForecast | string | `"ar2"` |  |
| nightscout.plugins.showPlugins | string | `""` |  |
| nightscout.plugins.timeago.enableAlerts | bool | `false` |  |
| nightscout.plugins.upbat.enableAlerts | bool | `false` |  |
| nightscout.plugins.upbat.urgent | int | `20` |  |
| nightscout.plugins.upbat.warn | int | `30` |  |
| nightscout.security.csp.enabled | bool | `false` |  |
| nightscout.security.csp.reportOnly | bool | `false` |  |
| nightscout.security.hsts.enabled | bool | `true` |  |
| nightscout.security.hsts.includeSubdomains | bool | `false` |  |
| nightscout.security.hsts.preload | bool | `false` |  |
| nightscout.security.insecureUseHttp | bool | `false` |  |
| nightscout.server.heartbeat | int | `60` |  |
| nightscout.server.hostname | string | `""` |  |
| nightscout.server.ssl.ca | string | `""` |  |
| nightscout.server.ssl.cert | string | `""` |  |
| nightscout.server.ssl.key | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.mountPath | string | `"/tmp/public"` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.maxUnavailable | int | `1` |  |
| podSecurityContext.fsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/api/v1/status"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.timeoutSeconds | int | `3` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"250m"` |  |
| resources.requests.memory | string | `"256Mi"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| service.annotations | object | `{}` |  |
| service.port | int | `1337` |  |
| service.targetPort | int | `1337` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| startupProbe.enabled | bool | `true` |  |
| startupProbe.probe.failureThreshold | int | `30` |  |
| startupProbe.probe.httpGet.path | string | `"/api/v1/status"` |  |
| startupProbe.probe.httpGet.port | string | `"http"` |  |
| startupProbe.probe.initialDelaySeconds | int | `10` |  |
| startupProbe.probe.periodSeconds | int | `5` |  |
| startupProbe.probe.timeoutSeconds | int | `3` |  |
| tolerations | list | `[]` |  |

## MongoDB Setup

This chart requires an external MongoDB instance. You have several options:

### Option 1: MongoDB Atlas (Recommended for Production)

1. Create a MongoDB Atlas cluster at https://www.mongodb.com/cloud/atlas
2. Create a database named `nightscout`
3. Get your connection string
4. Use it as `nightscout.mongodbUri`

### Option 2: Self-Hosted MongoDB

Deploy MongoDB in your cluster:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb \
  --set auth.rootPassword=rootpassword \
  --set auth.database=nightscout \
  --set auth.username=nightscout \
  --set auth.password=nightscout-password

# Use connection string:
# mongodb://nightscout:nightscout-password@mongodb:27017/nightscout
```

## Using Existing Secrets

To use an existing Kubernetes secret for MongoDB URI and API Secret:

```bash
# Create the secret
kubectl create secret generic nightscout-secrets \
  --from-literal=mongodb-uri='mongodb://user:pass@host:27017/nightscout' \
  --from-literal=api-secret='your-secret-min-12-chars'

# Install with existing secret
helm install my-nightscout . \
  --set nightscout.existingSecret=nightscout-secrets
```

## Upgrading

```bash
helm upgrade my-nightscout nightscout/nightscout -f my-values.yaml
```

## Uninstalling

```bash
helm uninstall my-nightscout
```

This will remove all resources created by the chart.

## Security Considerations

1. **Always use strong API secrets** (at least 12 characters, preferably random)
2. **Enable HTTPS** via Ingress with TLS certificates
3. **Consider NetworkPolicy** to restrict traffic
4. **Use authentication** by setting `nightscout.auth.defaultRoles: denied`
5. **Store secrets securely** using Kubernetes Secrets or external secret management
6. **Regular updates** - Keep Nightscout updated to the latest version

## Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=nightscout

# View pod logs
kubectl logs -l app.kubernetes.io/name=nightscout

# Describe pod for events
kubectl describe pod -l app.kubernetes.io/name=nightscout
```

### Cannot connect to MongoDB

- Verify MongoDB URI is correct
- Check network connectivity from pod to MongoDB
- Ensure MongoDB user has proper permissions
- Check NetworkPolicy if enabled

### Configuration not applying

- Verify values are set correctly
- Check deployment environment variables: `kubectl describe deployment`
- Restart pods: `kubectl rollout restart deployment/<name>`

## Support

- 📖 **Nightscout Documentation**: https://nightscout.github.io/
- 💬 **Discord Community**: https://discord.gg/rTKhrqz
- 🐛 **Report Issues**: https://github.com/nightscout/cgm-remote-monitor/issues
- 🌟 **GitHub**: https://github.com/nightscout/cgm-remote-monitor

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `helm lint` and `ct lint`
5. Submit a pull request

## License

This Helm chart is licensed under the Apache License 2.0.

Nightscout (cgm-remote-monitor) is licensed under AGPL-3.0.

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
