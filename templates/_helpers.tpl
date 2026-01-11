{{/*
Expand the name of the chart.
*/}}
{{- define "nightscout.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nightscout.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nightscout.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nightscout.labels" -}}
helm.sh/chart: {{ include "nightscout.chart" . }}
{{ include "nightscout.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nightscout.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nightscout.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nightscout.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nightscout.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper nightscout image name
*/}}
{{- define "nightscout.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}

{{/*
Return the secret name to use for MongoDB URI and API Secret
*/}}
{{- define "nightscout.secretName" -}}
{{- if .Values.nightscout.existingSecret }}
{{- .Values.nightscout.existingSecret }}
{{- else }}
{{- include "nightscout.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the secret key for MongoDB URI
*/}}
{{- define "nightscout.secretKeys.mongodbUri" -}}
{{- if .Values.nightscout.existingSecret }}
{{- .Values.nightscout.existingSecretKeys.mongodbUri | default "mongodb-uri" }}
{{- else }}
{{- "mongodb-uri" }}
{{- end }}
{{- end }}

{{/*
Return the secret key for API Secret
*/}}
{{- define "nightscout.secretKeys.apiSecret" -}}
{{- if .Values.nightscout.existingSecret }}
{{- .Values.nightscout.existingSecretKeys.apiSecret | default "api-secret" }}
{{- else }}
{{- "api-secret" }}
{{- end }}
{{- end }}
