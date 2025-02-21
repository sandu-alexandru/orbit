FROM golang:1.18-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o enrichment-service .

FROM alpine:latest
WORKDIR /app
COPY --from=build /app/enrichment-service .
EXPOSE 7000
CMD ["./enrichment-service"]
