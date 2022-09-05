#!/bin/bash

set -eu

cat > /etc/stunnel/node.psk << EOF
node:$PSK
EOF

chown stunnel4 /etc/stunnel/node.psk
chmod 0600 /etc/stunnel/node.psk

confd -onetime -backend env

exec "$@"
