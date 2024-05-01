#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
export TF_TOKEN_app_terraform_io="${INPUT_TERRAFORM_CLOUD_TOKEN}"

terraform init -backend=false
# shellcheck disable=SC2086
terraform validate -json \
  | jq -r '.diagnostics[] | "\(.range.filename):\(.range.start.line):\(.range.start.column): \(.detail)"' \
  | reviewdog -efm="%f:%l:%c:%m" \
      -name="terraform validate" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
