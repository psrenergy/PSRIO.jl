#!/usr/bin/env bash
set -euo pipefail

# Get the directory of the current script
basepath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_PROJECT_TOML="$1"

# Install juliaup if not found
if ! command -v juliaup >/dev/null 2>&1; then
  echo "[INFO] juliaup not found. Installing..."
  curl -fsSL https://install.julialang.org | sh
  echo 'export PATH="$HOME/.juliaup/bin:$PATH"' >>"$HOME/.bashrc"
  export PATH="$HOME/.juliaup/bin:$PATH"
fi

# Install Julia 1.6.1 if not already available
if ! juliaup list | grep -q "1.6.1"; then
  echo "[INFO] Installing Julia 1.6.1 via juliaup..."
  juliaup add 1.6.1
fi

# Run Julia with the same options
julia +1.6.1 --color=yes --project "$basepath/update_project_toml.jl" "$VERSION_PROJECT_TOML"
exit_code=$?

# Check exit code
if [ $exit_code -ne 0 ]; then
    exit 1
fi