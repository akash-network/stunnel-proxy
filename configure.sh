#!/bin/bash

set -eu

cat > /etc/stunnel/node.psk << EOF
node:$PSK
EOF

chown stunnel4 /etc/stunnel/node.psk
chmod 0600 /etc/stunnel/node.psk

cat > /etc/stunnel/stunnel.conf << EOF
# stunnel client config for TMKMS server

setuid = stunnel4
setgid = nogroup

pid = /var/run/stunnel4/stunnel4.pid

foreground = yes

# for debugging
debug = 7

[rpc]
client  = $CLIENT
accept  = $RPC_ACCEPT
connect = $RPC_HOST
ciphers = PSK
PSKidentity = node
PSKsecrets = /etc/stunnel/node.psk

[signer]
client  = $CLIENT
accept  = $SIGNER_ACCEPT
connect = $SIGNER_HOST
ciphers = PSK
PSKidentity = node
PSKsecrets = /etc/stunnel/node.psk
EOF

exec "$@"
