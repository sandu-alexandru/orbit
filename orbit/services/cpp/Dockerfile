# Build stage
FROM ubuntu:20.04 AS build

# Disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages including OpenSSL development libraries
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    make \
    libboost-all-dev \
    git \
    libssl-dev \
    openssl \
    pkg-config

# Install AMQP-CPP
WORKDIR /opt
RUN git clone https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git && \
    cd AMQP-CPP && \
    git checkout v4.3.21 && \
    mkdir build && \
    cd build && \
    cmake .. -DAMQP-CPP_BUILD_SHARED=ON -DAMQP-CPP_LINUX_TCP=ON && \
    make && \
    make install && \
    ldconfig

# Build the C++ service
WORKDIR /app
COPY . .

# Debug output to verify library existence
RUN ls -la /usr/local/lib/libamqpcpp* && \
    ldconfig -v | grep amqp

RUN rm -rf build && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make VERBOSE=1

# Run stage
FROM ubuntu:20.04
WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    libboost-system1.71.0 \
    && rm -rf /var/lib/apt/lists/*

# Copy the built executable and AMQP-CPP library
COPY --from=build /app/build/orbit_cpp_service .
COPY --from=build /usr/local/lib/libamqpcpp.so* /usr/local/lib/
RUN ldconfig

EXPOSE 9000
CMD ["./orbit_cpp_service"]
