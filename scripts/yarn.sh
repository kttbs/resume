#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NODE_DIR="$ROOT_DIR/.local/node"
COREPACK_DIR="$ROOT_DIR/.corepack"

if [ ! -x "$NODE_DIR/bin/node" ]; then
  echo "Local Node.js was not found. Run ./scripts/setup-local-node.sh first." >&2
  exit 1
fi

export PATH="$NODE_DIR/bin:$PATH"
export COREPACK_HOME="$COREPACK_DIR"

exec corepack yarn "$@"

