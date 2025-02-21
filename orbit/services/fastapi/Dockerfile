FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code into src directory
COPY ./src /app/src

# Set Python path to include src directory
ENV PYTHONPATH=/app/src

# Expose the FastAPI port
EXPOSE 8000

# Run the service using Uvicorn (adjusted path to main.py in src)
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
