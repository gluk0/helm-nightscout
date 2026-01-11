# MongoDB Integration

This chart now includes integrated MongoDB with auto-generated secrets for a seamless deployment experience.

## Features

- **Zero Configuration Required**: MongoDB and all secrets are auto-generated
- **Secure by Default**: Random strong passwords and API secrets
- **Persistent Storage**: MongoDB data persists across pod restarts
- **Flexible**: Can be disabled to use external MongoDB

## How It Works

### Auto-Generated Secrets

When you deploy Nightscout with `mongodb.enabled=true` (default), the chart automatically:

1. Generates a random 20-character password for MongoDB
2. Generates a random 24-character API secret for Nightscout
3. Creates the MongoDB connection URI with the generated credentials
4. Stores everything in a Kubernetes secret

### Secret Structure

The chart creates a secret with the following keys:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <release-name>-nightscout
data:
  mongodb-uri: <base64-encoded MongoDB connection string>
  api-secret: <base64-encoded API secret>
```

### Retrieving Generated Secrets

After deployment, retrieve your secrets:

**API Secret:**

```bash
kubectl get secret <release-name>-nightscout -n <namespace> \
  -o jsonpath='{.data.api-secret}' | base64 -d
```

**MongoDB URI:**

```bash
kubectl get secret <release-name>-nightscout -n <namespace> \
  -o jsonpath='{.data.mongodb-uri}' | base64 -d
```

## Configuration Options

### Default (Integrated MongoDB)

```yaml
mongodb:
  enabled: true
  auth:
    database: nightscout
    username: nightscout
    # password: ""  # Auto-generated if not set
  persistence:
    enabled: true
    size: 8Gi

nightscout:
  mongodbUri: ""   # Auto-generated from MongoDB subchart
  apiSecret: ""    # Auto-generated (24 chars)
```

### External MongoDB

Disable the integrated MongoDB and provide your own connection:

```yaml
mongodb:
  enabled: false

nightscout:
  mongodbUri: "mongodb://user:password@external-host:27017/nightscout"
  apiSecret: "your-secret-min-12-chars"
```

### Using Existing Secret

If you have an existing secret with MongoDB URI and API secret:

```yaml
mongodb:
  enabled: false

nightscout:
  existingSecret: "my-secret"
  existingSecretKeys:
    mongodbUri: "mongodb-uri"
    apiSecret: "api-secret"
```

### Custom Credentials (Fixed Passwords)

To set specific passwords instead of auto-generation:

```yaml
mongodb:
  enabled: true
  auth:
    password: "my-mongodb-password"

nightscout:
  apiSecret: "my-custom-api-secret-min-12-chars"
```

## MongoDB Subchart

The chart uses the [Bitnami MongoDB Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/mongodb) as a dependency.

### MongoDB Configuration

You can customize MongoDB through the `mongodb` values section:

```yaml
mongodb:
  enabled: true

  # Architecture
  architecture: standalone  # or 'replicaset' for HA

  # Authentication
  auth:
    enabled: true
    rootPassword: "root-password"  # Optional
    database: nightscout
    username: nightscout
    password: "user-password"  # Optional

  # Persistence
  persistence:
    enabled: true
    size: 8Gi
    storageClass: "fast-ssd"  # Optional

  # Resources
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi

  # Backup configuration (if using replicaset)
  backup:
    enabled: false
```

### High Availability Setup

For production deployments, use MongoDB in replicaset mode:

```yaml
mongodb:
  enabled: true
  architecture: replicaset
  replicaCount: 3
  persistence:
    enabled: true
    size: 20Gi
  resources:
    limits:
      cpu: 1000m
      memory: 2Gi
```

## Upgrade Considerations

### First Deployment

On first deployment with auto-generated secrets, the chart creates new random credentials.

### Upgrading Existing Deployments

**Important**: If you're upgrading from a version without MongoDB integration:

1. **Backup your data** before upgrading
2. Choose one option:
   - **Keep existing external MongoDB**: Set `mongodb.enabled=false`
   - **Migrate to integrated MongoDB**: Export data, enable MongoDB, import data

### Secret Persistence

Generated secrets persist across upgrades. The chart uses Helm's `lookup` function to retain existing secret values during upgrades (when using Helm 3+).
