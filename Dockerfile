FROM golang:1.22-alpine AS builder

RUN apk add --no-cache ffmpeg gifski

WORKDIR /go/src

# Copy all source files (fixes missing /config, /internal, etc.)
COPY . .

ENV CGO_ENABLED=0

# Download dependencies (modern replacement for go get -d)
RUN go mod download

# Build the binary
RUN go build -a -installsuffix cgo -o openapi .

FROM alpine:3.20

RUN apk add --no-cache ffmpeg gifski

COPY --from=builder /go/src/openapi /app/openapi

WORKDIR /app

CMD ["/app/openapi"]
