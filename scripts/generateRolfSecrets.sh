#!/usr/bin/env bash
set -euo pipefail

# Generate the secret files expected by nixos/custom/netcup.nix for Rolf.
#
# Default target directory:
#   /home/toni/resource/rolf/secrets
#
# Files created:
#   password-hash  - bcrypt hash for the login password
#   jwt-secret     - random signing secret for JWTs
#
# Usage:
#   ./scripts/generateRolfSecrets.sh
#   ./scripts/generateRolfSecrets.sh /home/toni/resource/rolf/secrets
#
# Notes:
# - Run this on the server, or copy the generated files there afterwards.
# - Re-running this script rotates both secrets.
# - Rotating jwt-secret invalidates existing logins.

TARGET_DIR="${1:-/home/toni/resource/rolf/secrets}"
PASSWORD_HASH_FILE="$TARGET_DIR/password-hash"
JWT_SECRET_FILE="$TARGET_DIR/jwt-secret"

if ! command -v openssl >/dev/null 2>&1; then
  echo "error: openssl is required" >&2
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "error: nix is required" >&2
  exit 1
fi

read -r -s -p "Rolf password: " PASSWORD
printf '\n'
read -r -s -p "Confirm password: " PASSWORD_CONFIRM
printf '\n'

if [[ -z "$PASSWORD" ]]; then
  echo "error: password must not be empty" >&2
  exit 1
fi

if [[ "$PASSWORD" != "$PASSWORD_CONFIRM" ]]; then
  echo "error: passwords do not match" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"

TMP_HASH=$(mktemp)
TMP_JWT=$(mktemp)
trap 'rm -f "$TMP_HASH" "$TMP_JWT"' EXIT

# htpasswd outputs ":<hash>" for an empty username, so strip the leading colon.
# It currently produces bcrypt hashes with a $2y$ prefix; the server normalizes
# that to $2b$ before calling bcrypt.compare().
printf '%s' "$PASSWORD" \
  | nix shell nixpkgs#apacheHttpd -c htpasswd -niBC 10 "" \
  | tr -d ':\n' > "$TMP_HASH"

openssl rand -base64 64 > "$TMP_JWT"

install -m 0400 "$TMP_HASH" "$PASSWORD_HASH_FILE"
install -m 0400 "$TMP_JWT" "$JWT_SECRET_FILE"

if id toni >/dev/null 2>&1; then
  chown toni:users "$PASSWORD_HASH_FILE" "$JWT_SECRET_FILE" || true
fi

cat <<EOF
Created:
  $PASSWORD_HASH_FILE
  $JWT_SECRET_FILE

Expected by config:
  ROLF_PASSWORD_HASH_FILE=$PASSWORD_HASH_FILE
  JWT_SECRET_FILE=$JWT_SECRET_FILE
EOF
