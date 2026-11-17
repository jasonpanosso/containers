#!/usr/bin/env bash
# Prints a JSON array of the apps/<name> directories with changes between two commits.
# Usage: changed-apps.sh BASE HEAD (needs GH_TOKEN and GITHUB_REPOSITORY)
set -euo pipefail
base=$1
head=$2
gh api "repos/${GITHUB_REPOSITORY}/compare/${base}...${head}" --jq '.files[].filename' \
    | awk -F/ '$1 == "apps" && NF > 2 { print $2 }' | sort -u | jq -Rnc '[inputs]'
