# Orbit: Interstellar Event Management System 

Designed as a microservices ecosystem where different services handle distinct aspects of simulated space mission data.

## Structure

### Telemetry Ingestion
 A Python service built with FastAPI provides a REST API endpoint that receives incoming telemetry data (e.g., simulated sensor readings from satellites). This service is instrumented with OpenTelemetry for tracing.

### Data Processing & Enrichment:

A Java service (using Spring Boot, Hibernate, and Maven) consumes tasks from a RabbitMQ queue (which the FastAPI service pushes tasks to) for further processing. This service also publishes events to Kafka for fan-out scenarios and integrates OpenTelemetry.
A Go service acts as an enrichment microservice, consuming raw data, applying lightweight computations, and storing enriched records into MongoDB.
Heavy Computation:

A C++ microservice performs computationally intensive algorithms on select telemetry data. It could work as a worker that picks jobs from RabbitMQ.
A Rust service subscribes to Kafka topics, doing real-time analysis (such as anomaly detection) and then publishing alerts or storing outcomes in PostgreSQL.
User Interfaces:

A React (TypeScript/Node.js) service provides a dynamic dashboard for real-time visualization of telemetry and alerts.
A Vaadin service (Java) offers an alternative UI with a rich, server-driven web interface, perhaps for mission management and historical data exploration.
Auxiliary Infrastructure:

### Databases
 PostgreSQL for transactional/processed data, MongoDB for raw or semi-structured telemetry data, and Elasticsearch for log indexing and searching.
Messaging: RabbitMQ is your go-to for general task queues (job dispatching to workers), while Kafka serves as the backbone for fan-out events (broadcasting new event alerts).

### Deployment & Orchestration

 All services run in isolated Docker containers and are managed as Kubernetes pods.


### Observability
 Each service exposes a /metrics endpoint for Prometheus scraping. Logs from every service get forwarded to both Loki and Logstash. Grafana will provide dashboards that visualize both metrics and log data.
