FROM iconoeugen/ruby-dev:latest
MAINTAINER info@vlad.eu

# install things globally, for great justice
ENV gitlab_repo ""
#https://gitlab.com/gitlab-org/gitlab-ce.git
ENV gitlab_shell_repo ""
#https://gitlab.com/gitlab-org/gitlab-shell.git
ENV gitlab_workhorse_repo ""
#https://gitlab.com/gitlab-org/gitlab-workhorse.git
ENV gitlab_development_kit_repo ""
#https://gitlab.com/gitlab-org/gitlab-development-kit.git

RUN dnf -y install postgresql libpqxx-devel postgresql-libs redis libicu-devel nodejs git ed cmake rpm-build gcc-c++ krb5-devel go postgresql-server postgresql-contrib zlib-devel \
    && dnf clean all

COPY entrypoint-gitlab.sh /entrypoint-gitlab.sh

EXPOSE 3000

CMD [ "/entrypoint-gitlab.sh", "/bin/bash" ]