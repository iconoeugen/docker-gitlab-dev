#!/bin/bash

echo "GITLAB_REPO=${GITLAB_REPO}"
echo "GITLAB_SHELL_REPO=${GITLAB_REPO}"
echo "GITLAB_WORKHORSE_REPO=${GITLAB_REPO}"

make gitlab_repo=${GITLAB_REPO} gitlab_shell_repo=${GITLAB_SHELL_REPO} gitlab_workhorse_repo=${GITLAB_WORKHORSE_REPO}

support/set-gitlab-upstream

exec "$@"