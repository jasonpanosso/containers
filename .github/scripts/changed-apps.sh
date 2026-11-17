#!/usr/bin/env bash
# Prints a JSON array of the apps/<name> directories with changes between two commits.
# If any file listed in REBUILD_ALL_PATHS (space-separated) changed, prints every app instead.
# Apps that no longer exist at HEAD (deleted) are left out.
# Usage: changed-apps.sh BASE HEAD (needs GH_TOKEN and GITHUB_REPOSITORY)
set -euo pipefail
base=$1
head=$2
files="$(gh api "repos/${GITHUB_REPOSITORY}/compare/${base}...${head}" --jq '.files[].filename')"
apps="$(gh api "repos/${GITHUB_REPOSITORY}/contents/apps?ref=${head}" --jq '.[] | select(.type == "dir") | .name')"

for path in ${REBUILD_ALL_PATHS:-}; do
    if grep -qxF "${path}" <<< "${files}"; then
        jq -Rnc '[inputs]' <<< "${apps}"
        exit 0
    fi
done

awk -F/ '$1 == "apps" && NF > 2 { print $2 }' <<< "${files}" | sort -u \
    | { grep -xF -f <(printf '%s\n' "${apps}") || true; } | jq -Rnc '[inputs]'
