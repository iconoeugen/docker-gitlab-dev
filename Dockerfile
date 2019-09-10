FROM iconoeugen/ruby-dev:latest
MAINTAINER info@vlad.eu

# install things globally, for great justice

# Default: https://gitlab.com/gitlab-org/gitlab-ce.git
ENV gitlab_repo ""
# Default: https://gitlab.com/gitlab-org/gitlab-shell.git
ENV gitlab_shell_repo ""
# Default: https://gitlab.com/gitlab-org/gitlab-workhorse.git
ENV gitlab_workhorse_repo ""
# Default: https://gitlab.com/gitlab-org/gitlab-development-kit.git
ENV gitlab_development_kit_repo ""

COPY yarn.repo /etc/yum.repos.d/

RUN dnf -y install rsync abrt git ed cmake rpm-build gcc-c++ go \
        postgresql-libs postgresql-server postgresql postgresql-contrib libpqxx-devel mysql-devel \
        sqlite-devel redis libicu-devel nodejs yarn krb5-devel zlib-devel perl-Digest-SHA && \
    dnf clean all

ENV PHANTOMJS_VERSION 2.1.1
RUN curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 | tar -xjC /tmp \
    && mv /tmp/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs /usr/bin/ \
    && rm -rf /tmp/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64

# Chrome for rspec
RUN dnf -y install chromedriver.x86_64 && \
    dnf -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    dnf clean all

RUN ln -s /workspace/gitlab-development-kit /home/git && \
    ln -s /usr/bin/git /usr/local/bin/git

COPY gdk-init.sh /etc/profile.d/gdk-init.sh

EXPOSE 3000

CMD [ "/bin/bash" ]
