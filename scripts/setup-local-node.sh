#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NODE_DIR="$ROOT_DIR/.local/node"
COREPACK_DIR="$ROOT_DIR/.corepack"
TMP_ARCHIVE_DIR="$ROOT_DIR/.local"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin) platform="darwin" ;;
  Linux) platform="linux" ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

case "$ARCH" in
  arm64|aarch64) arch="arm64" ;;
  x86_64) arch="x64" ;;
  *)
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
    ;;
esac

mkdir -p "$TMP_ARCHIVE_DIR" "$COREPACK_DIR"

archive_name="$(curl -fsSL https://nodejs.org/dist/latest-v20.x/SHASUMS256.txt | grep -E "node-v.+-${platform}-${arch}\\.tar\\.gz$" | awk '{print $2}' | head -n 1)"

if [ -z "$archive_name" ]; then
  echo "Failed to determine Node.js archive for ${platform}-${arch}" >&2
  exit 1
fi

archive_path="$TMP_ARCHIVE_DIR/$archive_name"

rm -rf "$NODE_DIR"
mkdir -p "$NODE_DIR"

curl -fsSL "https://nodejs.org/dist/latest-v20.x/$archive_name" -o "$archive_path"
tar -xzf "$archive_path" -C "$NODE_DIR" --strip-components=1
rm -f "$archive_path"

PATH="$NODE_DIR/bin:$PATH" COREPACK_HOME="$COREPACK_DIR" node -v
PATH="$NODE_DIR/bin:$PATH" COREPACK_HOME="$COREPACK_DIR" corepack --version

cat <<EOF
Local Node.js has been installed into:
  $NODE_DIR

Use Yarn only in this project with:
  export PATH="$NODE_DIR/bin:\$PATH"
  export COREPACK_HOME="$COREPACK_DIR"
  corepack yarn install
EOF


