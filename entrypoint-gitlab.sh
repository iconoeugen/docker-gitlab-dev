#!/bin/bash

echo "gitlab_repo=${gitlab_repo}"
echo "gitlab_shell_repo=${gitlab_shell_repo}"
echo "gitlab_workhorse_repo=${gitlab_workhorse_repo}"

gem install gitlab-development-kit
gdk init
cd gitlab-development-kit

gdk install ${gitlab_repo:+gitlab_repo=${gitlab_repo}} ${gitlab_shell_repo:+gitlab_shell_repo=${gitlab_shell_repo}} ${gitlab_workhorse_repo:+gitlab_workhorse_repo=${gitlab_workhorse_repo}}

support/set-gitlab-upstream

exec "$@"