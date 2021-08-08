# GHA

GitHub Action self-hosted runner. Only Docker client is bundled.

## ENV

+ `RUNNER_SCOPE`

+ One of:

  + `RUNNER_TOKEN`
  + `PAT`
  + `APP_ID`, `APP_KEY`, `INSTALLATION_ID`

+ `ACTIONS_RUNNER_INPUT_*`:

  + `ACTIONS_RUNNER_INPUT_NAME`
  + `ACTIONS_RUNNER_INPUT_RUNNERGROUP`
  + `ACTIONS_RUNNER_INPUT_LABELS`
