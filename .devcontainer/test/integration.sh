#!/bin/bash
# Load framework
source .devcontainer/util/source_framework.sh

printInfoSection "Running integration Tests for $RepositoryName"

#TODO: In here you add your assertions
#assertRunningPod dynatrace operator

#assertRunningPod dynatrace activegate

#assertRunningPod dynatrace oneagent

assertRunningPod opentelemetry-demo ad

assertRunningPod opentelemetry-demo frontend

assertRunningApp 30100
