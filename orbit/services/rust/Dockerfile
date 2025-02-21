FROM rust:1.67 AS builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --release

FROM debian:buster-slim
WORKDIR /app
COPY --from=builder /app/target/release/rust-analyzer .
EXPOSE 7500
CMD ["./rust-analyzer"]
