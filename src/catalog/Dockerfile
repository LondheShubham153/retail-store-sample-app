# FROM golang:1.23-alpine AS builder

# WORKDIR /app

# COPY go.mod go.sum ./
# RUN go mod download

# COPY . .

# RUN go build -o app

# FROM alpine:latest

# WORKDIR /root/

# COPY --from=builder /app/app .

# CMD ["./app"]

# Build stage
# updated to use debian image for better compatibility with CGO and to avoid issues with musl libc in alpine
FROM golang:1.23 AS builder

WORKDIR /app

# CGO enable
ENV CGO_ENABLED=1

RUN apt-get update && apt-get install -y gcc libc6-dev

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o catalog

# Run stage
FROM debian:bookworm-slim

WORKDIR /root/
COPY --from=builder /app/catalog .

EXPOSE 8080
CMD ["./catalog"]