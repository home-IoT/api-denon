# Build stage
FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git make

WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build arguments for version info
ARG VERSION=v1.0.0
ARG GIT_REVISION=unknown
ARG BUILD_TIME=unknown

# Build the binary to bin folder (matching Makefile convention)
RUN mkdir -p bin && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-X github.com/home-IoT/api-denon/internal/denon.GitRevision=${GIT_REVISION} \
              -X github.com/home-IoT/api-denon/internal/denon.BuildVersion=${VERSION} \
              -X github.com/home-IoT/api-denon/internal/denon.BuildTime=${BUILD_TIME}" \
    -o ./bin/api-denon \
    gen/cmd/denon-server/main.go

# Runtime stage
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/bin/api-denon /app/api-denon

# Create config directory
RUN mkdir -p /app/configs

# Expose default port
EXPOSE 8080

# Run the server
ENTRYPOINT ["/app/api-denon"]
CMD ["-c", "/app/configs/config.yml"]
