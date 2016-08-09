FROM iconoeugen/ruby-dev:latest
MAINTAINER info@vlad.eu

# install things globally, for great justice
ENV GITLAB_REPO https://gitlab.com/gitlab-org/gitlab-ce.git
ENV GITLAB_SHELL_REPO https://gitlab.com/gitlab-org/gitlab-shell.git
ENV GITLAB_WORKHORSE_REPO https://gitlab.com/gitlab-org/gitlab-workhorse.git
ENV GITLAB_DEVELOPMENT_KIT_REPO https://gitlab.com/gitlab-org/gitlab-development-kit.git

RUN dnf -y install postgresql libpqxx-devel postgresql-libs redis libicu-devel nodejs git ed cmake rpm-build gcc-c++ krb5-devel go postgresql-server postgresql-contrib zlib-devel \
    && dnf clean all

COPY entrypoint-gitlab.sh /entrypoint-gitlab.sh

EXPOSE 3000

CMD [ "/entrypoint-gitlab.sh", "/bin/bash" ]