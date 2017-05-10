#!/bin/bash

echo "gitlab_repo=${gitlab_repo}"
echo "gitlab_shell_repo=${gitlab_shell_repo}"
echo "gitlab_workhorse_repo=${gitlab_workhorse_repo}"

function gdk_install {
    gem install gitlab-development-kit
    gdk init /workspace/gitlab-development-kit

    CURRENT_DIR=$(pwd)

    cd /workspace/gitlab-development-kit
    gdk install -C /workspace/gitlab-development-kit ${gitlab_repo:+gitlab_repo=${gitlab_repo}} ${gitlab_shell_repo:+gitlab_shell_repo=${gitlab_shell_repo}} ${gitlab_workhorse_repo:+gitlab_workhorse_repo=${gitlab_workhorse_repo}}
    support/set-gitlab-upstream
    #cd ${CURRENT_DIR}
}

gdk_install
