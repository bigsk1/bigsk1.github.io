#!/usr/bin/env bash
set -euo pipefail
help() {
  echo 'Usage: bash tools/run.sh [--drafts] [-H HOST] [--port PORT] [-p]'
  echo 'Defaults: http://127.0.0.1:4000, development, published posts only.'
  echo '--drafts also previews published:false content. Keep the server local.'
}
host=127.0.0.1
port=4000
mode=development
extra=()
while (($#)); do
  case "$1" in
    --drafts) extra+=(--drafts --unpublished); shift ;;
    -H|--host|--port)
      [[ $# -ge 2 && -n "$2" && "$2" != -* ]] || { help >&2; exit 1; }
      if [[ "$1" == --port ]]; then port="$2"; else host="$2"; fi
      shift 2 ;;
    -p|--production) mode=production; shift ;;
    -h|--help) help; exit 0 ;;
    *) help >&2; exit 1 ;;
  esac
done
[[ "$port" =~ ^[0-9]{1,5}$ ]] && ((10#$port > 0 && 10#$port < 65536)) || {
  echo 'Port must be between 1 and 65535.' >&2; exit 1;
}
source "$(dirname -- "${BASH_SOURCE[0]}")/env.sh"
export JEKYLL_ENV="$mode"
exec bundle exec jekyll serve --livereload --host "$host" --port "$port" \
  --destination _site-preview "${extra[@]}"
