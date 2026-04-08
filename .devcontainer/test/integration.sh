#!/bin/bash
# Load framework
source .devcontainer/util/source_framework.sh

printInfoSection "Running integration Tests for $RepositoryName"

assertRunningPod opentelemetry-demo ad

assertRunningPod opentelemetry-demo frontend

printInfo "waiting for the app to start fully since we are not adding a wait in the post-start"

waitForAllReadyPods opentelemetry-demo 

assertRunningApp 30100
