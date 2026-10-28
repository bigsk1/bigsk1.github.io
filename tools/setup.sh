#!/usr/bin/env bash
# Recover the supported Ruby and install the committed gem versions.
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
if [[ "${1:-}" == --help ]]; then
  echo 'Usage: bash tools/setup.sh'
  echo 'Installs user-local mise/Ruby if needed, then gems in vendor/bundle.'
  exit 0
fi
[[ $# == 0 ]] || { echo 'Usage: bash tools/setup.sh' >&2; exit 1; }
for cmd in git curl make cc c++; do
  command -v "$cmd" >/dev/null || {
    echo "Missing $cmd. On Ubuntu/WSL, install prerequisites:" >&2
    echo 'sudo apt update && sudo apt install -y build-essential curl git libssl-dev libcurl4-openssl-dev pkg-config' >&2
    exit 1
  }
done
pin="$(<.ruby-version)"
if [[ "$(ruby -e 'print RUBY_VERSION' 2>/dev/null || true)" != "$pin" ]]; then
  mise_bin="$(command -v mise || true)"
  [[ -n "$mise_bin" ]] || mise_bin="$HOME/.local/bin/mise"
  if [[ ! -x "$mise_bin" ]]; then
    [[ "$(uname -s)" == Linux ]] || {
      echo "Install Ruby $pin using your version manager, then rerun this script." >&2
      exit 1
    }
    case "$(uname -m)" in
      x86_64) arch=x64 ;;
      aarch64) arch=arm64 ;;
      *) echo 'Automatic mise install supports Linux x64/arm64.' >&2; exit 1 ;;
    esac
    for cmd in curl tar sha256sum; do
      command -v "$cmd" >/dev/null || { echo "Install $cmd first." >&2; exit 1; }
    done
    mise_version=v2026.10.21
    archive="mise-$mise_version-linux-$arch.tar.gz"
    download_dir="$(mktemp -d)"
    trap 'rm -rf -- "$download_dir"' EXIT
    base="https://github.com/jdx/mise/releases/download/$mise_version"
    curl --fail --location --silent --show-error "$base/$archive" -o "$download_dir/$archive"
    curl --fail --location --silent --show-error "$base/SHASUMS256.txt" -o "$download_dir/checksums"
    (cd "$download_dir"; awk -v name="$archive" '$2 == name || $2 == "*" name' checksums > selected.sha256
      [[ -s selected.sha256 ]] && sha256sum --check selected.sha256)
    mkdir -p -- "$(dirname -- "$mise_bin")"
    tar -xzf "$download_dir/$archive" -C "$(dirname -- "$mise_bin")" --strip-components=2 mise/bin/mise
  fi
  # Official precompiled Ruby builds; no sudo or system Ruby changes.
  if ! "$mise_bin" where "ruby@$pin" >/dev/null 2>&1; then
    MISE_RUBY_COMPILE=false "$mise_bin" install "ruby@$pin"
  fi
fi
source tools/env.sh
bundler_version="$(awk '/^BUNDLED WITH$/{getline; gsub(/ /, ""); print}' Gemfile.lock)"
[[ -n "$bundler_version" ]] || { echo 'Restore the committed Gemfile.lock first.' >&2; exit 1; }
if ! gem list --installed --exact bundler --version "$bundler_version" >/dev/null; then
  gem install bundler --version "$bundler_version" --no-document
fi
BUNDLE_FROZEN=true bundle "_${bundler_version}_" install --jobs 4 --retry 3
bundle exec jekyll --version
echo 'Ready. Preview: bash tools/run.sh --drafts'
