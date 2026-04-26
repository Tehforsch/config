#!/usr/bin/env bash
set -euo pipefail

jj new "$JJ_BISECT_TARGET"
echo "Commit: $JJ_BISECT_TARGET"
read -p "[g]ood / [b]ad / [s]kip? " answer
case "$answer" in
  g) exit 0 ;;
  s) exit 125 ;;
  *) exit 1 ;;
esac
