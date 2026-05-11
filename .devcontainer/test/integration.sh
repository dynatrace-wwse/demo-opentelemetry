#!/bin/bash
# Load framework
source .devcontainer/util/source_framework.sh

printInfoSection "Running integration Tests for $RepositoryName"

assertRunningPod opentelemetry-demo ad

assertRunningPod opentelemetry-demo frontend

assertRunningApp otel-demo
