# =============================================================================
# TAAE Agent 2 — Linux (Alpine) uchun multi-stage Docker image
# -----------------------------------------------------------------------------
# Stage 1 (builder): Go yordamida statik binar yig'ish.
# Stage 2 (runtime): minimal alpine image ichida taae-agent foydalanuvchi ostida
#                    binar va configni joylab ishga tushirish.
# Build:   docker build -t taae/agent2:linux-latest -f scripts/linux-agent/Dockerfile .
# Run:     docker run --rm -p 10050:10050 taae/agent2:linux-latest
# =============================================================================

# -----------------------------------------------------------------------------
# Stage 1: builder
# -----------------------------------------------------------------------------
FROM golang:1.22-alpine AS builder

# Build muhitiga kerakli paketlar (git — versiya uchun, ca-certificates — HTTPS)
RUN apk add --no-cache git ca-certificates build-base

WORKDIR /src

# Go modullarini avval ko'chirish (cache'dan foydalanish uchun)
COPY src/go/go.mod src/go/go.sum ./
RUN go mod download

# Qolgan manba kodi
COPY src/go/ ./

# Statik build (CGO_ENABLED=0), Linux/amd64; arxitekturani build-arg orqali o'zgartirish mumkin
ARG TARGETARCH=amd64
ARG GIT_COMMIT=unknown
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=${TARGETARCH}

RUN go build -trimpath \
        -ldflags "-s -w -X main.GitCommit=${GIT_COMMIT}" \
        -o /out/taae_agent2 \
        ./cmd/zabbix_agent2

# -----------------------------------------------------------------------------
# Stage 2: runtime
# -----------------------------------------------------------------------------
FROM alpine:3.19 AS runtime

# OCI labellar — image metadatasi
LABEL org.opencontainers.image.title="TAAE Agent 2 (Linux)" \
      org.opencontainers.image.description="TAAE monitoring agent (Linux) — TAAE-brandlangan TAAE Agent 2 forki" \
      org.opencontainers.image.vendor="TAAE" \
      org.opencontainers.image.source="https://taae.local" \
      org.opencontainers.image.licenses="GPL-2.0"

# Runtime uchun minimal paketlar (CA root, vaqt zonalari, healthcheck uchun)
RUN apk add --no-cache ca-certificates tzdata \
 && addgroup -S taae-agent \
 && adduser -S -G taae-agent -H -s /sbin/nologin taae-agent \
 && mkdir -p /etc/taae/agent/taae_agent2.d \
             /var/log/taae/agent \
             /var/run/taae/agent \
             /var/lib/taae/agent \
 && chown -R taae-agent:taae-agent /etc/taae /var/log/taae /var/run/taae /var/lib/taae \
 && chmod 0750 /etc/taae/agent /var/log/taae/agent /var/run/taae/agent /var/lib/taae/agent

# Binar va config
COPY --from=builder /out/taae_agent2 /usr/sbin/taae_agent2
COPY scripts/linux-agent/taae_agent2.conf /etc/taae/agent/taae_agent2.conf

RUN chmod 0755 /usr/sbin/taae_agent2 \
 && chmod 0640 /etc/taae/agent/taae_agent2.conf \
 && chown root:root /usr/sbin/taae_agent2 \
 && chown taae-agent:taae-agent /etc/taae/agent/taae_agent2.conf

# Passiv tinglash porti
EXPOSE 10050

# Konteyner ichida root bo'lmagan foydalanuvchi
USER taae-agent

# Soddagina sog'liq tekshiruvi: agentdan o'ziga ping kalitini so'rash
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD /usr/sbin/taae_agent2 -t agent.ping -c /etc/taae/agent/taae_agent2.conf >/dev/null 2>&1 || exit 1

# Foreground rejimda ishga tushirish (systemd o'rniga konteyner PID 1)
ENTRYPOINT ["/usr/sbin/taae_agent2", "-f", "-c", "/etc/taae/agent/taae_agent2.conf"]
