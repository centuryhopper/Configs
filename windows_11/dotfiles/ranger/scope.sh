#!/usr/bin/env bash

FILE="$1"
FILETYPE="$(file -Lb --mime-type "$FILE")"

case "$FILETYPE" in
image/*)
  chafa -f symbols --colors=full --scale max "$FILE"
  exit 7
  ;;
esac

exit 1
