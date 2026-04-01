# Stage 1: The Builder
FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    openssl \
    tar

# Fetch certificate
RUN openssl s_client -showcerts -connect free-unlimited.hideservers.net:432 </dev/null 2>/dev/null \
    | openssl x509 -outform PEM > /usr/local/share/ca-certificates/hideme.crt

# Fetch and extract binary
RUN curl -L https://github.com/eventure/hide.client.linux/releases/download/0.9.10/hide.me-linux-amd64-0.9.10.tar.gz \
    | tar -xz -C /tmp/

# Stage 2: The Final Runner
FROM ubuntu:24.04

# Install only runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 \
    iptables \
    ca-certificates \
    expect \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /vpn

# Copy the cert and binary from the builder stage
COPY --from=builder /usr/local/share/ca-certificates/hideme.crt /usr/local/share/ca-certificates/
COPY --from=builder /tmp/hide.me /usr/bin/hide.me
COPY entrypoint.sh /entrypoint.sh

RUN update-ca-certificates --fresh \
    && ln -s /etc/ssl/certs/ca-certificates.crt /vpn/CA.pem \
    && chmod +x /usr/bin/hide.me \
    && chmod +x /entrypoint.sh

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/entrypoint.sh"]