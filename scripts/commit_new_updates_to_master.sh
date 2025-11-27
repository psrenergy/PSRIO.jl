h#!/usr/bin/env bash
set -euo pipefail

# Path to the directory where this script is located
basepath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read version from PSRIO.ver file
psrio_version="$(cat "$basepath/PSRIO.ver")"

git fetch
# Configure local git username
git config --local user.name "GithubPSRIOUpdater"

# Add the files to the commit
git add "$basepath/../Artifacts.toml"
git add "$basepath/../Project.toml"

# Create commit with the version from the file
git commit -m "[PSRIO update] version $psrio_version"

# Push changes to the master branch
git push origin master
