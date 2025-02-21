from fastapi import FastAPI, HTTPException, Request
import json
import pika
import traceback
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response
from pydantic import BaseModel

# Initialize FastAPI app
app = FastAPI()

# Prometheus metric: count of telemetry requests
telemetry_counter = Counter(
    'telemetry_requests_total', 
    'Total telemetry requests received'
)

# RabbitMQ connection settings
RABBITMQ_HOST = "orbit-rabbitmq"  # Adjust if needed (hostname in your Docker/K8s network)
RABBITMQ_QUEUES = {
    "logical": "telemetry_tasks_spring",
    "compute": "telemetry_tasks_cpp"
    }

class TelemetryData(BaseModel):
    device_id: str
    data_type: str = "logical"
    data: dict

def publish_to_rabbitmq(message: dict, queue: str):
    """Publishes a message to the RabbitMQ queue."""
    try:
        connection = pika.BlockingConnection(
            pika.ConnectionParameters(host=RABBITMQ_HOST, credentials=pika.PlainCredentials('guest', 'guest'))
        )
        channel = connection.channel()
        channel.queue_declare(queue=queue, durable=True)
        channel.basic_publish(
            exchange='',
            routing_key=queue,
            body=json.dumps(message),
            properties=pika.BasicProperties(delivery_mode=2)  # persistent messages
        )
    except Exception as e:
        print(f"Failed to publish to RabbitMQ: {e}")
        print(traceback.format_exc())
        raise Exception(f"Failed to publish to RabbitMQ: {e}")
    finally:
        if 'connection' in locals() and connection.is_open:
            connection.close()

@app.post("/telemetry")
def ingest_telemetry(request: TelemetryData):
    """
    Endpoint to receive telemetry data.
    Increments a Prometheus counter and pushes the data to RabbitMQ.
    """
    telemetry_counter.inc()  # Increment metric counter

    try:
        data = request.dict()
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid JSON payload")

    try:
        publish_to_rabbitmq(data, queue=RABBITMQ_QUEUES.get(request.data_type, "logical"))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    return {"status": "success", "message": "Telemetry data enqueued"}

@app.get("/metrics")
async def metrics():
    """Exposes Prometheus metrics."""
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

# Optional: To enable OpenTelemetry instrumentation,
# you can run the server using:
# opentelemetry-instrument uvicorn main:app --host 0.0.0.0 --port 8000
