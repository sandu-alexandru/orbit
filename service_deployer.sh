#!/bin/bash
# Filename: service_deployer.sh
# Usage: ./service_deployer.sh {docker|k8s} service_name
# Example: ./service_deployer.sh docker fastapi

# Service port configurations using old-style array declaration
SERVICE_NAMES=("fastapi" "spring" "vaadin" "react" "cpp" "go" "rust")
SERVICE_PORTS=("8000" "8080" "8081" "3000" "9000" "8090" "7000")

# Function to display usage information
usage() {
    echo "Usage: $0 {docker|k8s} service_name"
    echo "Available services and their ports:"
    for i in "${!SERVICE_NAMES[@]}"; do
        echo "  - ${SERVICE_NAMES[$i]} (port: ${SERVICE_PORTS[$i]})"
    done
    exit 1
}

# Validate service name and get port
get_service_port() {
    local service=$1
    for i in "${!SERVICE_NAMES[@]}"; do
        if [[ "${SERVICE_NAMES[$i]}" == "$service" ]]; then
            echo "${SERVICE_PORTS[$i]}"
            return
        fi
    done
    echo "Error: Unknown service '$service'"
    usage
    exit 1
}

# Function to check if port is in use
is_port_in_use() {
    local port=$1
    lsof -i :$port >/dev/null 2>&1
    return $?
}

# Function to deploy a service in Docker
deploy_docker() {
    local service=$1
    local port=$(get_service_port "$service")
    
    # Check if port is already in use
    if is_port_in_use "$port"; then
        echo "Error: Port $port is already in use"
        echo "Stopping existing container if it exists..."
        docker stop orbit-${service}-container >/dev/null 2>&1
        docker rm orbit-${service}-container >/dev/null 2>&1
    fi
    
    echo "Building Docker image for $service..."
    docker build -t orbit-${service}:latest orbit/services/${service} || { echo "Docker build failed for ${service}"; exit 1; }
    
    echo "Running Docker container for $service on port $port..."
    docker run -d \
        --name orbit-${service} --network docker_default \
        -p "${port}:${port}" \
        orbit-${service}:latest || { echo "Docker run failed for ${service}"; exit 1; }
    
    echo "Deployed $service as Docker container successfully on port $port"
}

# Check for exactly two arguments
if [ "$#" -ne 2 ]; then
    usage
fi

# Environment (docker or k8s) and service name are taken from arguments
ENVIRONMENT=$1
SERVICE_NAME=$2

# Dispatch based on the chosen environment
case "$ENVIRONMENT" in
    docker)
        deploy_docker "$SERVICE_NAME"
        ;;
    k8s)
        deploy_k8s "$SERVICE_NAME"
        ;;
    *)
        usage
        ;;
esac