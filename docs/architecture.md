# Orbit: Interstellar Event Management System - Architecture Document

## 1. Project Overview

**Orbit** is a microservices-based system designed to simulate the ingestion, processing, and visualization of telemetry and mission events from various space assets. The project serves as a pet project to showcase your skills across multiple languages, frameworks, and modern DevOps practices, including containerization, orchestration, messaging, and observability.

## 2. Tech Stack Summary

### Languages:
- **Python:** FastAPI for telemetry ingestion.
- **Java:** Spring Boot (processing service with Hibernate) and Vaadin for user interface.
- **C++:** Computational service for heavy processing.
- **Rust:** Real-time analysis service.
- **Go:** Enrichment service.
- **JavaScript/TypeScript:** React dashboard (Node.js).

### Frameworks & Tools:
- **FastAPI** (Python)
- **Spring Boot** & **Hibernate** (Java)
- **Vaadin** (Java)
- **Maven:** Build management for Java services.
- **RabbitMQ:** General task queue mechanism.
- **Kafka:** Event streaming for fan-out notifications.
- **Elasticsearch:** Log indexing and search.
- **MongoDB:** Storage for raw/semi-structured telemetry data.
- **PostgreSQL:** Processed and transactional data storage.
- **Docker & Kubernetes:** Containerization and orchestration.
- **Jenkins:** CI/CD (build server, linting, code analysis).
- **Prometheus:** Metrics collection.
- **Grafana:** Dashboarding and visualization.
- **Loki & Logstash:** Centralized logging.
- **OpenTelemetry:** Distributed tracing (integrated in Python and Java services).

## 3. High-Level System Components

### 3.1. Microservices

- **Telemetry Ingestion Service (Python/FastAPI):**
  - Receives external telemetry data via REST API.
  - Pushes processing tasks to RabbitMQ.
  - Exposes `/metrics` for Prometheus scraping.
  - Integrated with OpenTelemetry for distributed tracing.

- **Data Processing Service (Java/Spring Boot):**
  - Consumes tasks from RabbitMQ.
  - Uses Hibernate for ORM and interacts with PostgreSQL.
  - Publishes events to Kafka for fan-out processing.
  - Exposes `/metrics` and integrates with OpenTelemetry.

- **Computational Service (C++):**
  - Pulls heavy processing jobs from RabbitMQ.
  - Performs computationally intensive algorithms on telemetry data.

- **Enrichment Service (Go):**
  - Processes and enriches raw telemetry data.
  - Stores enriched data in MongoDB.
  - Optionally exposes APIs for data retrieval.

- **Real-Time Analysis Service (Rust):**
  - Subscribes to Kafka topics for real-time event processing.
  - Performs anomaly detection or similar analysis.
  - Persists processed results into PostgreSQL.

- **User Interface Services:**
  - **React Dashboard (JavaScript/TypeScript):**
    - Provides a dynamic, real-time visualization dashboard.
    - Consumes Kafka event streams for live updates.
  - **Vaadin UI (Java):**
    - Offers a server-driven web interface for mission management and historical data exploration.

### 3.2. Supporting Infrastructure

- **Messaging Systems:**
  - **RabbitMQ:** For task-based messaging (e.g., FastAPI sending jobs to processing workers like C++ and Spring Boot services).
  - **Kafka:** For event broadcasting and fan-out scenarios (e.g., Spring Boot publishing events for Rust analysis and React visualization).

- **Data Storage:**
  - **MongoDB:** Stores raw or semi-structured telemetry data (handled by the Enrichment Service).
  - **PostgreSQL:** Manages processed, transactional data (used by the Processing and Real-Time Analysis services).
  - **Elasticsearch:** Aggregates and indexes logs for advanced searching.

## 4. Deployment & Infrastructure

- **Containerization & Orchestration:**
  - Each microservice is containerized using Docker.
  - Kubernetes orchestrates the deployment, ensuring services run as isolated pods.

- **CI/CD Pipeline:**
  - Jenkins (or similar) will be set up to automate builds, linting, and container image creation.
  - Unit and integration tests are integrated into the pipeline.

- **Observability & Monitoring:**
  - Every service exposes a `/metrics` endpoint for Prometheus.
  - Grafana dashboards visualize metrics and log data aggregated by Loki and Logstash.
  - OpenTelemetry provides distributed tracing for Python and Java services.

## 5. Visual Diagrams (To Be Created)

- **High-Level Architecture Diagram:**  
  Visual representation of all microservices, messaging systems, databases, and observability components.
  
- **Data Flow Diagram:**  
  Illustrates the path from telemetry ingestion, through processing, enrichment, analysis, and ultimately to visualization.
  
- **Communication Patterns Diagram:**  
  Maps out interactions (e.g., FastAPI → RabbitMQ → C++/Spring Boot, Spring Boot → Kafka → Rust/React).

*Suggested Tools:* Draw.io, Lucidchart, or any other diagramming tool.

## 6. Messaging & Data Persistence Patterns

### Messaging:
- **RabbitMQ:**
  - Utilized for point-to-point messaging.
  - Example: Telemetry Ingestion Service pushes tasks consumed by C++ and Spring Boot services.
  
- **Kafka:**
  - Employed for event streaming.
  - Example: Spring Boot publishes events to Kafka, which are then consumed by Rust for real-time analysis and by React for dashboard updates.

### Data Persistence:
- **MongoDB:**  
  Used by the Enrichment Service to store raw telemetry data.
  
- **PostgreSQL:**  
  Used for storing processed, transactional data from the Real-Time Analysis Service.
  
- **Elasticsearch:**  
  Aggregates logs for search and analysis.

## 7. Observability & Logging Strategy

### Metrics Collection:
- Each service exposes a `/metrics` endpoint.
- **Prometheus** scrapes these endpoints, storing and processing the metrics.
- **Grafana** is used to build dashboards for visualizing performance metrics.

### Logging:
- Logs from all services are forwarded to both **Loki** and **Logstash**.
- Grafana (and potentially Kibana) provide interfaces for log analysis and troubleshooting.

### Distributed Tracing:
- **OpenTelemetry** is integrated in the Python and Java services.
- Enables tracing across service boundaries to diagnose performance issues and monitor request flows.

## 8. Rationale & Design Decisions

- **Microservices Architecture:**  
  Promotes separation of concerns, scalability, and resilience.
  
- **Dual Messaging Systems:**  
  - **RabbitMQ** is ideal for guaranteed task-based messaging.
  - **Kafka** is optimal for high-throughput event streaming and multi-subscriber scenarios.
  
- **Centralized Observability:**  
  Enables efficient monitoring, troubleshooting, and performance tuning across all services.
  
- **Containerization & Kubernetes:**  
  Provides consistency across development and production-like environments.

```
          +------------------+
          |   External API   |
          | (Telemetry Push) |
          +------------------+
                   │
                   ▼
          +------------------+
          |   FastAPI (Py)   |   <-- OpenTelemetry tracing, exposes /metrics
          +------------------+
                   │
                   ▼
          +------------------+       +---------------------+
          |   RabbitMQ       | <---- |  C++ Worker Service |
          | (Task Queueing)  |       | (Heavy Computation) |
          +------------------+       +---------------------+
                   │
                   ▼
          +--------------------------+
          |  Spring Boot Processor   | <-- Consumes from RabbitMQ, publishes to Kafka
          |    (Java, Hibernate)     | <-- OpenTelemetry tracing, exposes /metrics
          +--------------------------+
                   │
         +---------+----------+
         |                    |
         ▼                    ▼
+----------------+    +----------------+
| Kafka Producer |    |    Kafka     |   <-- Fan-out streaming events
| (Event Publisher)   |    Broker    |
+----------------+    +----------------+
         │                    │
         ▼                    ▼
+----------------+     +---------------------+
|  Rust Analyzer |     |    React Dashboard  |
|   (Rust)       |     |   (TypeScript)      |
| (Real-time)    |     | (UI/Visualization)  |
+----------------+     +---------------------+
         │
         ▼
+----------------+
|  PostgreSQL    | <-- Processed/Transactional Data
+----------------+

                   │
                   ▼
          +------------------+
          | Go Enricher (Go) | <-- Enriches raw telemetry & writes to MongoDB
          +------------------+
                   │
                   ▼
          +------------------+
          |    MongoDB       | <-- Raw/Semi-structured telemetry storage
          +------------------+

          +-------------------+
          |  Vaadin UI (Java) |  <-- Alternative UI, may interface with PostgreSQL/MongoDB
          +-------------------+

```