#!/bin/bash
# Filename: monitoring_deployer.sh
# Usage: ./monitoring_deployer.sh {docker|k8s} component_name
# Example: ./monitoring_deployer.sh docker prometheus

# Function to display usage information
usage() {
    echo "Usage: $0 {docker|k8s} component_name (prometheus, grafana, loki, logstash)"
    exit 1
}

# Ensure exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    usage
fi

ENVIRONMENT=$1
COMPONENT=$2

# Function to deploy a monitoring component in Docker
deploy_docker() {
    local comp=$1
    echo "Building Docker image for ${comp}..."
    docker build -t orbit-${comp}:latest orbit/monitoring/${comp} || { echo "Docker build failed for ${comp}"; exit 1; }

    echo "Running Docker container for ${comp}..."
    case ${comp} in
        prometheus)
            docker run -d -p 9090:9090 --network docker_default --name orbit-${comp} orbit-${comp}:latest
            ;;
        grafana)
            docker run -d -p 3000:3000 --network docker_default --name orbit-${comp} orbit-${comp}:latest
            ;;
        loki)
            docker run -d -p 3100:3100 --network docker_default --name orbit-${comp} orbit-${comp}:latest
            ;;
        logstash)
            docker run -d -p 5044:5044 --network docker_default --name orbit-${comp} orbit-${comp}:latest
            ;;
        *)
            echo "Unknown monitoring component: ${comp}"
            exit 1
            ;;
    esac
    echo "Deployed ${comp} as Docker container successfully."
}

# Function to deploy a monitoring component in Kubernetes
deploy_k8s() {
    local comp=$1
    echo "Deploying ${comp} to Kubernetes..."
    kubectl apply -f orbit/monitoring/${comp}/deployment.yaml || { echo "Kubernetes deployment failed for ${comp}"; exit 1; }
    echo "Deployed ${comp} in Kubernetes successfully."
}

# Dispatch based on the chosen environment
case "$ENVIRONMENT" in
    docker)
        deploy_docker "$COMPONENT"
        ;;
    k8s)
        deploy_k8s "$COMPONENT"
        ;;
    *)
        usage
        ;;
esac
