#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Environment preparation
# ---------------------------

# Base directory where this script is located
BASE_PATH="$(cd "$(dirname "$0")" && pwd)/"

AWS_KEY="${1:-}"
SECRET_AWS_KEY="${2:-}"

if [ -z "$AWS_KEY" ] || [ -z "$SECRET_AWS_KEY" ]; then
  echo "Usage: $0 <AWS_KEY> <SECRET_AWS_KEY>"
  exit 1
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

echo "[INFO] Cloning psrio-distribution..."
git clone --depth=1 -b develop \
  "https://bitbucket.org/psr/psrio-distribution.git" \
  "${BASE_PATH}psrio-distribution"

cp "${BASE_PATH}psrio-distribution/linux/PSRIO.ver" \
  "${BASE_PATH}PSRIO.ver"

# ---------------------------
# Clone ArtifactsGenerator
# ---------------------------

echo "[INFO] Cloning ArtifactsGenerator..."
git clone --depth=1 -b 0.5.0 \
  "https://github.com/psrenergy/ArtifactsGenerator.jl.git" \
  "${BASE_PATH}ArtifactsGenerator.jl"

# ---------------------------
# Update artifacts
# ---------------------------

echo "[INFO] Updating artifacts..."
julia +1.6.1 --color=yes \
  --project="${BASE_PATH}ArtifactsGenerator.jl" \
  "${BASE_PATH}update_artifacts.jl" \
  "${BASE_PATH}psrio-distribution" \
  "psrio-distribution" "PSRIO" \
  "${BASE_PATH}../Artifacts.toml" \
  "$AWS_KEY" "$SECRET_AWS_KEY"

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
#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Environment preparation
# ---------------------------

# Base directory where this script is located
BASE_PATH="$(cd "$(dirname "$0")" && pwd)/"

AWS_KEY="${1:-}"
SECRET_AWS_KEY="${2:-}"

if [ -z "$AWS_KEY" ] || [ -z "$SECRET_AWS_KEY" ]; then
  echo "Usage: $0 <AWS_KEY> <SECRET_AWS_KEY>"
  exit 1
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

echo "[INFO] Cloning psrio-distribution..."
git clone --depth=1 -b develop \
  "https://bitbucket.org/psr/psrio-distribution.git" \
  "${BASE_PATH}psrio-distribution"

cp "${BASE_PATH}psrio-distribution/linux/PSRIO.ver" \
  "${BASE_PATH}PSRIO.ver"

# ---------------------------
# Clone ArtifactsGenerator
# ---------------------------

echo "[INFO] Cloning ArtifactsGenerator..."
git clone --depth=1 -b 0.5.0 \
  "https://github.com/psrenergy/ArtifactsGenerator.jl.git" \
  "${BASE_PATH}ArtifactsGenerator.jl"

# ---------------------------
# Update artifacts
# ---------------------------

echo "[INFO] Updating artifacts..."
julia +1.6.1 --color=yes \
  --project="${BASE_PATH}ArtifactsGenerator.jl" \
  "${BASE_PATH}update_artifacts.jl" \
  "${BASE_PATH}psrio-distribution" \
  "psrio-distribution" "PSRIO" \
  "${BASE_PATH}../Artifacts.toml" \
  "$AWS_KEY" "$SECRET_AWS_KEY"

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
