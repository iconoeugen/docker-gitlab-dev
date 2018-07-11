# Gitlab development environment docker image

A docker image to run Gitlab development environment based on Fedora.

> Based on: [iconoeugen/ruby-dev](https://hub.docker.com/r/iconoeugen/ruby-dev/)

> Using: [gdk](https://gitlab.com/gitlab-org/gitlab-development-kit)

## Environment Variables

- **gitlab_repo**: Gitlab fork repository url. If left empty then the official repository will be cloned (Defaults: "")
- **gitlab_shell_repo**: Gitlab Shell fork repository url. If left empty then the official repository will be cloned (Defaults: "")
- **gitlab_workhorse_repo**: Gitlab Workhorse fork repository url. If left empty then the official repository will be cloned (Defaults: "")

## Usage example

After configuring the development environment as described in [iconoeugen/fedora-dev](https://github.com/iconoeugen/docker-fedora-dev), you can start
a development container as:

```
dev run iconoeugen/gitlab-dev
```

Working on a fork for example:

```
dev -e gitlab_repo=https://gitlab.com/myproject/gitlab-ce.git iconoeugen/gitlab-dev
```

## Prepare development environemnt

Export the following environment variables (change the values to match your envionment) to easily make use of commands
copy-paste in following sections:

``` bash
export GITLAB_WORK_DIR=~/work/gitlab/hvlad/gitlab-development-kit
export GITLAB_REPO=https://gitlab.com/hvlad/gitlab-ce.git
```

Prepare the development environment on the host system:

``` bash
mkdir ${GITLAB_WORK_DIR}
```

Run the development container that will also attach an interactive console to the running container:

``` bash
dev run -d ${GITLAB_WORK_DIR} -e gitlab_repo="${GITLAB_REPO}" iconoeugen/gitlab-dev
```

Development URL: (http://localhost:3000)
Development admin account: `root` / `5iveL!fe`

## More interactive consoles

If you want to start more interactive consoles that attache to the already running container use the command:

``` bash
dev exec -d ${GITLAB_WORK_DIR} iconoeugen/gitlab-dev
```

## Gitlab App

To execute any of the following command you have to open a development console that is attached to the already
running container:

``` bash
dev exec -d ${GITLAB_WORK_DIR} iconoeugen/gitlab-dev
```

### Manage DB

#### Run DB only

The Postgresql server will not listen on the TCP Port 5432 by default, which can be changed by adding the `localhost` hostname to `postgresql` command the `-h` argument value in the `Procfile`.

To start the Postgresql and Redis servers:

``` bash
cd /workspace/gitlab-development-kit
gdk run db
```

#### Remove DB data

If you want to start with a fresh DB the you have to remove all DB data and create a new instance and reintialize the schema:

``` bash
rm -rf /workspace/gitlab-development-kit/postgresql/data
make
```

#### Troubleshooting

- If you get the error message `FATAL:  role "postgres" does not exist` then you have to create the superuser:
  ``` bash
  createuser -s postgres -h localhost -p 5432
  ```

### Update development environment

If the configuration files provided with Gitlab development kit you have to regenerate all config file:

``` bash
cd /workspace/gitlab-development-kit
make update
```

### Delete and regenerate all config files created by GDK

If the configuration files provided with Gitlab development kit you have to regenerate all config file:

``` bash
cd /workspace/gitlab-development-kit
gdk reconfigure
```

### Compile

This is an extra dependency for openid connect:

``` bash
echo "gem 'omniauth-openid-connect',:git => 'https://github.com/iconoeugen/omniauth-openid-connect.git', :branch => 'upstream_forks'" >> /workspace/gitlab-development-kit/gitlab/Gemfile
```

Install gem dependencies:

``` bash
cd /workspace/gitlab-development-kit/gitlab
bundle install --without mysql production --jobs 4
```

### Start

Development Procfile mappings to production:

- rails-background-jobs	=> sidekiq
- rails-web		=> unicorn
- gitlab-workhorse	=> gitlab-workhorse

``` bash
cd /workspave/gitlab-development-kit
./run app
```

#### Troubleshoting

- Git cli not found:
  ```
  # curl -v http://localhost:3000
  ...
  > No such file or directory - /usr/local/bin/git  
  ```
  make sure the Git is correctly set:
  ``` bash
  sed -e "s|/usr/local/bin/git|/usr/bin/git|" -i /workspace/gitlab-development-kit/gitlab/config/gitlab.yml
  ```
- Gitaly config error:
  ```
  gitaly.1                | level=fatal msg="load config" config_path=/workspace/gitlab-development-kit/gitaly/config.toml error="load linguist colors: exit status 1; stderr: \"\""
  ```
  This can be due to missing Gem required by Gitaly:
  ``` bash
  cd /workspace/gitlab-development-kit/gitaly/ruby
  bundle bundle install --without mysql production --jobs 4
  ```
- Rails web error:
  ```
  rails-web.1             | E, ERROR -- : getaddrinfo: Name or service not known (SocketError)
  ```
  Change hostnames to localhost:
  ```
  sed -e "s/port 0/port 6379/" -i /workspace/gitlab-development-kit/redis/redis.conf
  cd /workspace/gitlab-development-kit/gitlab/config
  mv redis.cache.yml redis.cache.yml.orig
  cp redis.cache.yml.example redis.cache.yml
  mv redis.queues.yml redis.queues.yml.orig
  cp redis.queues.yml.example redis.queues.yml
  mv redis.shared_state.yml redis.shared_state.yml.orig
  cp redis.shared_state.yml.example redis.shared_state.yml
  mv resque.yml resque.yml.orig
  cp resque.yml.example resque.yml
  mv database.yml database.yml.orig
  cp database.yml.postgresql database.yml
  ```
  

### Check running app

Navigate in a browser to Gitlab homepage: (http://localhost:3000/)

## Test

- RSpec: https://www.jetbrains.com/help/ruby/8.0/using-rspec-in-ruby-projects.html

## Using RubyMine

RubyMine is comercial Cross-platform intelligent IDE for productive Ruby / Rails development that allows a trial phase
of 30 days or requires a license to activate.

### Install IDE

Inside development container:

``` bash
export RUBYMINE_VERSION="2017.1.2"
curl -L https://download-cf.jetbrains.com/ruby/RubyMine-${RUBYMINE_VERSION}.tar.gz | tar xvz -C ~/
unlink ~/RubyMine
ln -s ~/RubyMine-${RUBYMINE_VERSION} ~/RubyMine
```

### Start IDE

Start RubyMine inside development container:

``` bash
/home/default/RubyMine/bin/rubymine.sh
```

### Configure IDE

#### Open new project

Open a new project located at:

``` bash
/workspace/gitlab-development-kit/gitlab
```

#### Configure

- Configure DB

  Edit file `/workspce/gitlab-development-kit/Procfile` the `postgresql:` line:

  ``` bash
  sed -e "s/-h ''/-h '0.0.0.0'/" -i /workspace/gitlab-development-kit/Procfile
  #sed -e "s|/home/git|/workspace/gitlab-development-kit" -i Procfile
  ```

  Enable Database Tools: `Menu -> View -> Tool Windows -> Database`:
  1. Open Properties dialog for `Rails gitlab: development`:
  1. Import drivers from Drivers -> PostgreSQL tab (on left side)
  1. Configure Imported Data Source and test connection
    - Host: `localhost`
    - Port: `5432`
    - Database: `gitlabhq_development`
    - User: `<shell_user_name>`
    - Password: `<empty>`

- Debug gitlab unicorn

  Comment out the `rails-web` lines in `/workspace/Procfile` to avoid `./run app` starting unicorn.

  ``` bash
  sed -e "s/rails-web:/#rails-web:/" -i /workspace/gitlab-development-kit/Procfile
  ```

  Edit run configuration: `Menu -> Run -> Edit Configurations`:
  1. Open Properties dialog for ` Rails -> Development: gitlab`
	2. Select Configuration Tab
	  - Server: `Unicorn`
	  - IP addr: `0.0.0.0`
	  - Port: `3001`
	  - Server args: `-c /workspace/gitlab-development-kit/gitlab/config/unicorn.rb`
	  - Environment: `development`
	  - Dummy app: `test/dummy`
	  - Run browser: `Unchecked`
			- `http://localhost:3001`
			- `Unchecked` Start Javascript debuger
	3. Bundler Tab
	  - Run the script in context of the bundle: `Checked`

### Run Debug

    Edit run configuration: `Menu -> Run -> Debug Development: gitlab
