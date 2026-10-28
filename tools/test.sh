#!/usr/bin/env bash
# The same production build and local link checks used by GitHub Actions.
set -euo pipefail
config=_config.yml
while (($#)); do
  case "$1" in
    -c|--config)
      [[ $# -ge 2 ]] || { echo 'Missing config file.' >&2; exit 1; }
      config="$2"; shift 2 ;;
    -h|--help) echo 'Usage: bash tools/test.sh [-c CONFIG[,CONFIG]]'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done
source "$(dirname -- "${BASH_SOURCE[0]}")/env.sh"
export JEKYLL_ENV=production
baseurl="$(bundle exec ruby -rjekyll -e 'print Jekyll.configuration({"config" => ARGV[0].split(","), "quiet" => true})["baseurl"]' "$config")"
[[ -z "$baseurl" || "$baseurl" =~ ^/[a-zA-Z0-9_/-]+$ && "$baseurl" != *..* ]] || {
  echo 'Unsupported baseurl for local validation.' >&2; exit 1;
}
rm -rf -- "$CHIRPY_ROOT/_site"
bundle exec jekyll build --config "$config" --destination "_site$baseurl" --trace
bundle exec ruby tools/check-output.rb "_site$baseurl"
bundle exec htmlproofer _site --disable-external \
  --ignore-urls '/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/'
