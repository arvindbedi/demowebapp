#!/usr/bin/env bash
# Trigger a Jenkins job. Usage: ./remoteTrigger.sh [job-name]
# Settings live in .remoteTrigger.env (see .remoteTrigger.env.example).

set -euo pipefail

source "$(dirname "$0")/.remoteTrigger.env"

JOB="${1:-$JENKINS_JOB}"

code=$(curl -s -o /dev/null -w '%{http_code}' -X POST \
  -u "$JENKINS_USER:$JENKINS_API_TOKEN" \
  -H "ngrok-skip-browser-warning: true" \
  "$JENKINS_URL/job/$JOB/build?token=$JENKINS_BUILD_TOKEN")

if [[ $code == 201 ]]; then
  echo "OK: build of '$JOB' queued"
else
  echo "FAILED: HTTP $code" >&2
  exit 1
fi
