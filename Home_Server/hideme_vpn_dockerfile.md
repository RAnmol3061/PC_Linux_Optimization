Dockerfile

----------------------------------------------------------------------------------------
# Stage 1: The Builder
FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    openssl \
    tar

# Fetch certificate
RUN openssl s_client -showcerts -connect free-nl.hideservers.net:432 </dev/null 2>/dev/null \
    | openssl x509 -outform PEM > /usr/local/share/ca-certificates/hideme.crt

# Fetch and extract binary
RUN curl -L https://github.com/eventure/hide.client.linux/releases/download/0.9.10/hide.me-linux-amd64-0.9.10.tar.gz \
    | tar -xz -C /tmp/

# Stage 2: The Final Runner
FROM ubuntu:24.04-slim

# Install only runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 \
    iptables \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the cert and binary from the builder stage
COPY --from=builder /usr/local/share/ca-certificates/hideme.crt /usr/local/share/ca-certificates/
COPY --from=builder /tmp/hide.me /usr/bin/hide.me

RUN update-ca-certificates --fresh \
    && ln -s /etc/ssl/certs/ca-certificates.crt /CA.pem \
    && chmod +x /usr/bin/hide.me

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/usr/bin/hide.me"]
------------------------------------------------------------------------------------------

sudo docker build -t my-hideme-vpn .
sudo docker run -it --name vpn-gateway --cap-add=NET_ADMIN --device /dev/net/tun my-hideme-vpn -s 192.168.1.0/24 connect us-free.hideservers.net


hide.me -u <username> token <serverlink eg - free.net>
hide.me connect <server-name>
hide.me -s 192.168.1.0/24 connect free-nl.hideservers.net

#This will generate a acesstoken.txt
sudo docker cp accessToken.txt vpn-gateway:/accessToken.txt # This will copy the token to the container

docker exec vpn-gateway curl ifconfig.me #To check IP

sudo docker run -it --name vpn-gateway \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  my-hideme-vpn


ip route flush table 55555
ip rule del table 55555


