#!/bin/bash
# filepath: setup-orbit-project.sh

# Create root directory
mkdir -p orbit

# Create main subdirectories
mkdir -p orbit/{services,monitoring,ci/jenkins}

# Create service directories with their base files
mkdir -p orbit/services/{fastapi,spring,vaadin,react,cpp,go,rust}

# FastAPI service
mkdir -p orbit/services/fastapi/src
touch orbit/services/fastapi/{requirements.txt,Dockerfile,deployment.yaml}

# Spring service
mkdir -p orbit/services/spring/src
touch orbit/services/spring/{pom.xml,Dockerfile,deployment.yaml}

# Vaadin service
mkdir -p orbit/services/vaadin/src
touch orbit/services/vaadin/{pom.xml,Dockerfile,deployment.yaml}

# React service
mkdir -p orbit/services/react/src
touch orbit/services/react/{package.json,Dockerfile,deployment.yaml}

# C++ service
mkdir -p orbit/services/cpp/src
touch orbit/services/cpp/{CMakeLists.txt,Dockerfile,deployment.yaml}

# Go service
mkdir -p orbit/services/go/src
touch orbit/services/go/{go.mod,Dockerfile,deployment.yaml}

# Rust service
mkdir -p orbit/services/rust/src
touch orbit/services/rust/{Cargo.toml,Dockerfile,deployment.yaml}

# Create monitoring and config directories
mkdir -p orbit/monitoring/{prometheus,grafana/dashboards,loki,logstash}

touch orbit/monitoring/prometheus/Dockerfile
touch orbit/monitoring/prometheus/prometheus.yml

touch orbit/monitoring/grafana/Dockerfile
touch orbit/monitoring/grafana/dashboards/dashboard.json

touch orbit/monitoring/loki/loki-config.yaml
touch orbit/monitoring/loki/Dockerfile

touch orbit/monitoring/logstash/logstash.conf
touch orbit/monitoring/logstash/Dockerfile

# Create database directories
mkdir -p orbit/db/{elasticsearch,postgres,mongodb}

touch orbit/db/elasticsearch/Dockerfile
touch orbit/db/elasticsearch/elasticsearch.yml

touch orbit/db/postgres/Dockerfile
touch orbit/db/postgres/init.sql

touch orbit/db/mongodb/Dockerfile
touch orbit/db/mongodb/mongod.conf

# Create broker directories
mkdir -p orbit/brokers/{kafka,rabbitmq}

touch orbit/brokers/kafka/Dockerfile
touch orbit/brokers/kafka/server.properties

touch orbit/brokers/rabbitmq/Dockerfile
touch orbit/brokers/rabbitmq/rabbitmq.conf

# Create CI/CD configuration
touch orbit/ci/jenkins/Jenkinsfile

echo "Project structure created successfully!"