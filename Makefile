.PHONY: help lint test deps build clean install uninstall

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: ## Update Helm chart dependencies
	@echo "Updating chart dependencies..."
	helm dependency update
	@echo "Dependencies updated successfully"

build: deps ## Build (package) the Helm chart
	@echo "Building Helm chart..."
	helm package .
	@echo "Chart built successfully"

lint: ## Lint the Helm chart
	@echo "Linting Helm chart..."
	helm lint .
	ct lint --config ct.yaml
	@echo "Lint completed"

test: deps ## Run chart tests
	@echo "Running chart tests..."
	helm template test . --debug
	@echo "Template generation successful"

install: deps ## Install the chart locally (requires kubectl context)
	@echo "Installing Helm chart..."
	helm upgrade --install nightscout . \
		--namespace nightscout \
		--create-namespace \
		--wait
	@echo "Chart installed successfully"

uninstall: ## Uninstall the chart
	@echo "Uninstalling Helm chart..."
	helm uninstall nightscout --namespace nightscout
	@echo "Chart uninstalled"

clean: ## Clean up generated files
	@echo "Cleaning up..."
	rm -rf charts/ *.tgz Chart.lock
	@echo "Cleanup completed"

dry-run: deps ## Perform a dry-run installation
	@echo "Performing dry-run installation..."
	helm upgrade --install nightscout . \
		--namespace nightscout \
		--create-namespace \
		--dry-run --debug

show-values: ## Show all chart values
	@echo "Chart values:"
	@helm show values .

template: deps ## Generate Kubernetes manifests from the chart
	@echo "Generating templates..."
	helm template nightscout . --namespace nightscout

check-deps: ## Check if dependencies are up to date
	@echo "Checking dependencies..."
	@if [ -f Chart.lock ]; then \
		echo "Dependencies are locked. Run 'make deps' to update."; \
		cat Chart.lock; \
	else \
		echo "No Chart.lock found. Run 'make deps' to download dependencies."; \
	fi
