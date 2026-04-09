# ──────────────────────────────────────────
# Stage 1: Builder
# ──────────────────────────────────────────
FROM golang:1.25-alpine AS builder

# Herramientas mínimas para compilar
RUN apk --no-cache add git

WORKDIR /app

# Descarga dependencias primero (aprovechar caché de Docker)
COPY go.mod go.sum ./
RUN go mod download

# Copia el resto del código fuente
COPY . .

# Compila el binario estático para Linux
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-s -w" -o ac-api .

# ──────────────────────────────────────────
# Stage 2: Imagen final (mínima)
# ──────────────────────────────────────────
FROM alpine:3.21

# Certificados TLS y zona horaria
RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app

# Copia solo el binario compilado
COPY --from=builder /app/ac-api .

# Puerto que expone la API Gin
EXPOSE 8080

# Usuario no-root por seguridad
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

ENTRYPOINT ["./ac-api"]

