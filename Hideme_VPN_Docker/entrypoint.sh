#!/bin/bash

ln -sf /etc/ssl/certs/ca-certificates.crt /vpn/CA.pem

TOKEN_FILE="/vpn/accessToken.txt"
LOCAL_NET="${VPN_LOCAL_RANGE:-192.168.1.0/24}"

generate_token() {
    echo "--- [LOG] Token not found. Starting automated login... ---"
    
    /usr/bin/expect <<EOF
    # log_user 0 prevents the password from being printed in terminal logs
    log_user 0
    set timeout 20
    spawn hide.me -u "$VPN_USER" token free-unlimited.hideservers.net
    expect "Password:"
    send "$VPN_PASS\r"
    expect eof
EOF

    if [ -f "$TOKEN_FILE" ]; then
        echo "--- [SUCCESS] Access token generated and saved to $TOKEN_FILE. ---"
    else
        echo "--- [ERROR] Failed to generate token. Please check your credentials. ---"
        exit 1
    fi
}

if [ ! -f "$TOKEN_FILE" ]; then
    generate_token
else
    echo "--- [LOG] Found existing access token. Skipping login. ---"
fi

echo "--- [LOG] Initializing VPN connection for network $LOCAL_NET... ---"
exec hide.me -s "$LOCAL_NET" connect free-unlimited.hideservers.net
