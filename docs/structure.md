
```
orbit/
├── README.md
├── docs/                           # Documentation, architecture diagrams, API docs, etc.
│   └── architecture.md
├── deployment/                     # Deployment configurations for Docker & Kubernetes
│   ├── docker/
│   │   ├── fastapi/Dockerfile
│   │   ├── spring/Dockerfile
│   │   ├── vaadin/Dockerfile
│   │   ├── react/Dockerfile
│   │   ├── cpp/Dockerfile
│   │   ├── go/Dockerfile
│   │   └── rust/Dockerfile
│   └── kubernetes/                 # Kubernetes manifests for each service
│       ├── fastapi-deployment.yml
│       ├── spring-deployment.yml
│       ├── vaadin-deployment.yml
│       ├── react-deployment.yml
│       ├── cpp-deployment.yml
│       ├── go-deployment.yml
│       ├── rust-deployment.yml
│       ├── rabbitmq-deployment.yml
│       ├── kafka-deployment.yml
│       ├── mongodb-deployment.yml
│       ├── postgresql-deployment.yml
│       └── elasticsearch-deployment.yml
├── services/                       # Microservices source code
│   ├── fastapi/                    # Python + FastAPI service
│   │   ├── src/
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   ├── spring/                     # Java Spring Boot processor
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   ├── vaadin/                     # Java Vaadin UI service
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   ├── react/                      # React (TypeScript/Node.js) dashboard
│   │   ├── src/
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── cpp/                        # C++ computational service
│   │   ├── src/
│   │   ├── CMakeLists.txt
│   │   └── Dockerfile
│   ├── go/                         # Go enrichment service
│   │   ├── src/
│   │   ├── go.mod
│   │   └── Dockerfile
│   └── rust/                       # Rust real-time processing service
│       ├── src/
│       ├── Cargo.toml
│       └── Dockerfile
├── config/                         # Centralized configuration for observability tools
│   ├── prometheus/
│   │   └── prometheus.yml
│   ├── grafana/
│   │   └── dashboards/             # Preconfigured dashboards
│   ├── loki/
│   │   └── loki-config.yaml
│   └── logstash/
│       └── logstash.conf
├── monitoring/                     # Additional monitoring/observability setup docs or scripts
│   └── README.md
└── ci/                             # CI/CD configuration (e.g., Jenkins pipelines)
    └── jenkins/                    
        └── Jenkinsfile
```