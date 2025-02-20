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