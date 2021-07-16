#!/bin/sh

set -ex

if [ -z "$RUNNER_SCOPE" ]; then
  echo "Must define RUNNER_SCOPE env"
  exit 255
fi

runner_url="https://github.com/${RUNNER_SCOPE}"
if [ -n "$GHE_HOSTNAME" ]; then
    runner_url="https://${GHE_HOSTNAME}/${RUNNER_SCOPE}"
fi


if [ -n "$PAT" ]; then
  base_api_url="https://api.github.com"
  if [ -n "$GHE_HOSTNAME" ]; then
    base_api_url="https://${GHE_HOSTNAME}/api/v3"
  fi

  orgs_or_repos="orgs"
  if echo "$RUNNER_SCOPE" | grep -q "/"; then
    orgs_or_repos="repos"
  fi

  RUNNER_TOKEN=$(
    curl -s -X POST \
    -H "accept: application/vnd.github.everest-preview+json" -H "authorization: token ${PAT}" \
    "${base_api_url}/${orgs_or_repos}/${RUNNER_SCOPE}/actions/runners/registration-token" | \
    grep '"token"' | sed -E 's/.*"([^\"]+)".*/\1/')
fi

if [ "null" = "$RUNNER_TOKEN" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "Failed to get a token"
  exit 255
fi

./config.sh --unattended --replace --url "$runner_url" --token "$RUNNER_TOKEN"
exec "./bin/runsvc.sh"
