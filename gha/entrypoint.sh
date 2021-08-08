#!/bin/sh

set -ex

if [ -z "$RUNNER_TOKEN" ]; then
  RUNNER_TOKEN=$(gha-register)
fi

runner_url="https://github.com/${RUNNER_SCOPE}"

unset PAT APP_ID APP_KEY INSTALLATION_ID

./config.sh --unattended --replace --url "$runner_url" --token "$RUNNER_TOKEN"
exec "./bin/runsvc.sh"
