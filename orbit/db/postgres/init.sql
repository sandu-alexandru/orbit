-- Create a sample table for telemetry data
CREATE TABLE IF NOT EXISTS telemetry (
    id SERIAL PRIMARY KEY,
    data JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
