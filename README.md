# Gitlab development environment docker image

A docker image to run Gitlab development environment based on Fedora.

> Based on: [iconoeugen/ruby-dev](https://hub.docker.com/r/iconoeugen/ruby-dev/)
> Using: [gdk](https://gitlab.com/gitlab-org/gitlab-development-kit)

## Environment Variables

- **gitlab_repo**: Gitlab fork repository url. If left empty then the official repository will be cloned (Defaults: "")
- **gitlab_shell_repo**: Gitlab Shell fork repository url. If left empty then the official repository will be cloned (Defaults: "")
- **gitlab_workhorse_repo**: Gitlab Workhorse fork repository url. If left empty then the official repository will be cloned (Defaults: "")

## Usage example

After configuring the development environment as described in [iconoeugen/fedora-dev](https://hub.docker.com/r/iconoeugen/fedora-dev/), you can start
a development container as:

```
dev run iconoeugen/gitlab-dev
```

Working on a fork for example:

```
dev -e gitlab_repo=https://gitlab.com/myproject/gitlab-ce.git iconoeugen/gitlab-dev
```