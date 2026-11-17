#!/usr/bin/env bash
# Prints a JSON array of the apps/<name> directories with changes between two commits.
# If any file listed in REBUILD_ALL_PATHS (space-separated) changed, prints every app instead.
# Usage: changed-apps.sh BASE HEAD (needs GH_TOKEN and GITHUB_REPOSITORY)
set -euo pipefail
base=$1
head=$2
files="$(gh api "repos/${GITHUB_REPOSITORY}/compare/${base}...${head}" --jq '.files[].filename')"

for path in ${REBUILD_ALL_PATHS:-}; do
    if grep -qxF "${path}" <<< "${files}"; then
        gh api "repos/${GITHUB_REPOSITORY}/contents/apps?ref=${head}" \
            --jq '.[] | select(.type == "dir") | .name' | jq -Rnc '[inputs]'
        exit 0
    fi
done

awk -F/ '$1 == "apps" && NF > 2 { print $2 }' <<< "${files}" | sort -u | jq -Rnc '[inputs]'
