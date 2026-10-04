## 1. Launch the Codespace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/dynatrace-wwse/demo-opentelemetry){target="_blank"}

!!! tip "Machine size"
    The demo runs many services. Choose a machine with at least **4 cores**.

While the Codespace is created, `.devcontainer/post-create.sh`:

1. starts a local k3d Kubernetes cluster and installs `k9s`,
2. installs the upstream Helm chart `open-telemetry/opentelemetry-demo` into the namespace
   `opentelemetry-demo` and waits for all pods to be ready,
3. exposes the demo's `frontend-proxy` through the nginx ingress as the app `otel-demo`.

## 2. Open the demo

Run `printGreeting` in the terminal to see the URL of `otel-demo`. From there:

| Path | What you get |
|---|---|
| `/` | the Astronomy Shop web store |
| `/jaeger/ui/` | Jaeger UI |
| `/grafana/` | Grafana |
| `/loadgen/` | Load generator UI |
| `/feature/` | Feature flags UI |

## 3. Useful functions

| Function | What it does |
|---|---|
| `deployOpentelemetryDemo` | install the demo (again) |
| `undeployOpentelemetryDemo` | uninstall it and delete the namespace |

<div class="grid cards" markdown>
- [Cleanup :octicons-arrow-right-24:](cleanup.md)
</div>
