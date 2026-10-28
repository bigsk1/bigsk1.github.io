#!/usr/bin/env bash
# Source from Bash to select this site's Ruby and isolated gems.
CHIRPY_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$CHIRPY_ROOT" || return 1
chirpy_ruby_version="$(<.ruby-version)"
if [[ "$(ruby -e 'print RUBY_VERSION' 2>/dev/null)" != "$chirpy_ruby_version" ]]; then
  chirpy_mise="$(command -v mise || true)"
  if [[ -z "$chirpy_mise" && -x "$HOME/.local/bin/mise" ]]; then
    chirpy_mise="$HOME/.local/bin/mise"
  fi
  chirpy_ruby_dir=""
  if [[ -n "$chirpy_mise" ]]; then
    chirpy_ruby_dir="$("$chirpy_mise" where "ruby@$chirpy_ruby_version" 2>/dev/null || true)"
  fi
  if [[ ! -x "$chirpy_ruby_dir/bin/ruby" ]]; then
    echo "Ruby $chirpy_ruby_version is required. Run: bash tools/setup.sh" >&2
    return 1
  fi
  export PATH="$chirpy_ruby_dir/bin:$PATH"
fi
# Restored gem paths may contain extensions for an older Ruby.
unset GEM_HOME GEM_PATH
export BUNDLE_GEMFILE="$CHIRPY_ROOT/Gemfile"
export BUNDLE_PATH="$CHIRPY_ROOT/vendor/bundle"
export BUNDLE_APP_CONFIG="$CHIRPY_ROOT/.bundle"
export CHIRPY_ROOT
