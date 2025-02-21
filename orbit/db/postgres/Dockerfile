FROM postgres:14

# Set environment variables for initial database setup
ENV POSTGRES_DB=orbitdb
ENV POSTGRES_USER=orbituser
ENV POSTGRES_PASSWORD=orbitpass

COPY init.sql /docker-entrypoint-initdb.d/