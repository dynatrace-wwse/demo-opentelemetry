#!/bin/bash
# ======================================================================
#          ------- Custom Functions -------                            #
#  Space for adding custom functions so each repo can customize as.    # 
#  needed.                                                             #
# ======================================================================


customFunction(){
  printInfoSection "This is a custom function that calculates 1 + 1"

  printInfo "1 + 1 = $(( 1 + 1 ))"

}

installDynatraceOperator(){
  printInfoSection "Installing latest Dynatrace Operator"
  helm install dynatrace-operator oci://public.ecr.aws/dynatrace/dynatrace-operator --create-namespace --namespace dynatrace
}

deployOpentelemetryDemo(){

  NAMESPACE="opentelemetry-demo"

  printInfoSection "Installing latest Opentelemetry Demo in NS='$NAMESPACE' from https://opentelemetry.io/docs/demo/kubernetes-deployment/"

  helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
  
  helm install opentelemetry-demo open-telemetry/opentelemetry-demo --namespace $NAMESPACE --create-namespace

  getNextFreeAppPort true
  PORT=$(getNextFreeAppPort)
  if [[ $? -ne 0 ]]; then
    printWarn "Application can't be deployed"
    return 1
  fi

  printInfo "Change $NAMESPACE frontend service from ClusterIP to NodePort"
  
  kubectl patch service frontend-proxy --namespace=$NAMESPACE --patch='{"spec": {"type": "NodePort"}}'

  printInfo "Exposing the $NAMESPACE frontend-proxy in NodePort $PORT"

  kubectl patch service frontend-proxy --namespace=$NAMESPACE --type='json' --patch="[{\"op\": \"replace\", \"path\": \"/spec/ports/0/nodePort\", \"value\":$PORT}]"

  printInfo "$NAMESPACE deployed succesfully and should handle request in port $PORT"
  
  printWarn "$NAMESPACE is quite heavy and might take a while to schedule all pods $PORT"

}

undeployOpentelemetryDemo(){

  printInfoSection "Uninstalling Opentelemetry Demo"

  helm uninstall opentelemetry-demo --namespace opentelemetry-demo
  
  printInfo "Deleting namespace opentelemetry-demo"

  kubectl delete namespace opentelemetry-demo
}

deployAstroshopDemo(){

  ASTROSHOPDIR="astroshop"

  printInfoSection "Deploying Demo.Live Astroshop"
  if [[ "$ARCH" != "x86_64" ]]; then
    printWarn "This version of the Astroshop only supports AMD/x86 architectures and not ARM, exiting deployment..."
    return 1
  fi

  getNextFreeAppPort true
  #PORT=$(getNextFreeAppPort)
  PORT=30100
  if [[ $? -ne 0 ]]; then
    printWarn "Application can't be deployed"
    return 1
  fi

  NAMESPACE="astroshop"

  kubectl apply -n $NAMESPACE -f $REPO_PATH/.devcontainer/apps/$ASTROSHOPDIR/yaml/astroshop-deployment.yaml

  printInfo "Recreating secret containing OTEL endpoint and token if exists"
  
  kubectl -n $NAMESPACE delete secret dt-credentials

  kubectl -n $NAMESPACE create secret generic dt-credentials --from-literal="DT_API_TOKEN=$DT_INGEST_TOKEN" --from-literal="DT_ENDPOINT=$DT_OTEL_ENDPOINT"
  
  waitForAllPods $NAMESPACE

  printInfo "Change astroshop frontend service from ClusterIP to NodePort"
  
  kubectl patch service frontend-proxy --namespace=$NAMESPACE --patch='{"spec": {"type": "NodePort"}}'

  printInfo "Exposing the astroshop frontend in NodePort $PORT"

  kubectl patch service frontend-proxy --namespace=astroshop --type='json' --patch="[{\"op\": \"replace\", \"path\": \"/spec/ports/0/nodePort\", \"value\":$PORT}]"

  waitAppCanHandleRequests $PORT

  printInfo "Astroshop deployed succesfully and handling request in port $PORT"
  
  printWarn "FlagD UI issue, workaround adding the service after flagd pod is initialized"

  kubectl apply -f $REPO_PATH/.devcontainer/apps/$ASTROSHOPDIR/yaml/flagd-ui-service.yaml --namespace=$NAMESPACE

}


undeployAstroshopDemo(){

  printInfoSection "Uninstalling Astroshop Demo"

  printInfo "Deleting namespace astroshop"

  kubectl delete namespace astroshop
  
}