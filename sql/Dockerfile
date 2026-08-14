FROM golang:1.26 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o api ./api

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/api .
EXPOSE 1323
CMD ["./api-server"]