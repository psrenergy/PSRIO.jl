#!/usr/bin/env bash
set -euo pipefail
# ---------------------------
# Environment preparation
# ---------------------------
# Base directory where this script is located
BASE_PATH="$(cd "$(dirname "$0")" && pwd)/"
DIST_BRANCH="${1:-develop}"

# AWS credentials are optional. If passed as arguments ($2 = access key id,
# $3 = secret access key, $4 = optional session token), they are exported.
# Otherwise the script continues and relies on the default credential provider
# chain (env vars, instance/task IAM role, etc.).
if [ -n "${2:-}" ] && [ -n "${3:-}" ]; then
  export AWS_ACCESS_KEY_ID="$2"
  export AWS_SECRET_ACCESS_KEY="$3"
  [ -n "${4:-}" ] && export AWS_SESSION_TOKEN="$4"
fi

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

# ---------------------------
# Initial cleanup
# ---------------------------

echo "[INFO] Cleaning directory..."
rm -rf "${BASE_PATH}psrio-distribution"
rm -rf "${BASE_PATH}ArtifactsGenerator.jl"
rm -f "${BASE_PATH}Project.toml"
rm -f "${BASE_PATH}Manifest.toml"

# ---------------------------
# Clone psrio-distribution
# ---------------------------

echo "[INFO] Cloning psrio-distribution (branch: $DIST_BRANCH)..."
git clone --depth=1 -b "$DIST_BRANCH" \
  "https://github.com/psrenergy/psrio-distribution.git" \
  "${BASE_PATH}psrio-distribution"

cp "${BASE_PATH}psrio-distribution/linux/PSRIO.ver" \
  "${BASE_PATH}PSRIO.ver"

# ---------------------------
# Clone ArtifactsGenerator
# ---------------------------

echo "[INFO] Cloning ArtifactsGenerator..."
git clone --depth=1 -b 0.8.1 \
  "https://github.com/psrenergy/ArtifactsGenerator.jl.git" \
  "${BASE_PATH}ArtifactsGenerator.jl"

# ---------------------------
# Update artifacts
# ---------------------------
chmod +x "${BASE_PATH}psrio-distribution/windows/PSRIO.exe"

echo "[INFO] Updating artifacts..."
julia +1.6.1 --color=yes \
  --project="${BASE_PATH}ArtifactsGenerator.jl" \
  "${BASE_PATH}update_artifacts.jl" \
  "${BASE_PATH}psrio-distribution" \
  "psrio-distribution" "PSRIO" \
  "${BASE_PATH}../Artifacts.toml"

# ---------------------------
# Cleanup after build
# ---------------------------

echo "[INFO] Cleaning temporary directories..."
rm -rf "${BASE_PATH}psrio-distribution"
rm -rf "${BASE_PATH}ArtifactsGenerator.jl"

# ---------------------------
# Run package tests
# ---------------------------

echo "[INFO] Running package tests..."
julia +1.6.1 --color=yes \
  --project="${BASE_PATH}.." \
  -e "import Pkg; Pkg.test()"

echo "[INFO] All tasks completed successfully!"
