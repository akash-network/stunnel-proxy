#!/bin/bash

set -eu

if [[ -n "$RPC_ALLOW" ]]; then
  IFS=',' read -ra ips <<< "$RPC_ALLOW"
  rules=()
  for ip in "${ips[@]}"; do
    rules+=("allow $ip;")
  done
  rules+=("deny all;")
  export RPC_RULES=$( IFS=$'\n'; echo "${rules[*]}" )
fi

export RPC_PORT="${RPC_PORT:-26657}"

if [[ -n "$SIGNER_ALLOW" ]]; then
  IFS=',' read -ra ips <<< "$SIGNER_ALLOW"
  rules=()
  for ip in "${ips[@]}"; do
    rules+=("allow $ip;")
  done
  rules+=("deny all;")
  export SIGNER_RULES=$( IFS=$'\n'; echo "${rules[*]}" )
fi

export SIGNER_PORT="${SIGNER_PORT:-26658}"

/docker-entrypoint.sh "$@"