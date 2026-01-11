# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-11

### Added

- Initial release of Nightscout Helm Chart ported from personal charts.
- Comprehensive environment variable configuration covering all Nightscout options up to the latest version of cgm-remote-monitor.
- Support for configuration of all Nightscout plugins
- Authentication and authorization configuration
- Extensive alarm configuration (thresholds, snooze times, timeago alerts)
- Display and UI customization options
- Bridge support for Dexcom Share and MiniMed CareLink
- Security settings (HSTS, CSP, HTTP/HTTPS)
- Support for existing Kubernetes secrets
- MongoDB collection name configuration
- Startup probe for better initialization handling
- NetworkPolicy for traffic restriction
- PodDisruptionBudget for high availability
- HorizontalPodAutoscaler support
- Comprehensive health checks (startup, liveness, readiness)
- Security contexts with non-root user
- Detailed NOTES.txt with configuration summary and next steps
- GitHub Actions workflows for CI/CD
  - Automated linting and testing
  - Chart release automation
  - Documentation generation
- Chart testing configuration (ct.yaml)
- Values schema validation (values.schema.json)
- helm-docs template for automated documentation
- CI test values file
- Contributing guidelines

### Features

- Full Nightscout environment variable coverage
- Plugin-specific configurations
- Production-ready defaults
- High availability support
- Security best practices
- Comprehensive documentation

### Documentation

- Detailed README with examples
- Installation and upgrade instructions
- MongoDB setup guidance
- Security considerations
- Troubleshooting guide
- Contributing guidelines

[1.0.0]: https://github.com/YOUR_ORG/helm-nightscout/releases/tag/v1.0.0
