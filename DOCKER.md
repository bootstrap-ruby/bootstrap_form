# Working With Docker

This repository offers experimental support for a couple of ways to develop using Docker, if you're interested:

- Using `docker-compose`. This way is less tested, and is an attempt to make the Docker container a more complete environment where you can conveniently develop and release the gem.
- Using just a simple Dockerfile. This way works for simple testing, but doesn't make it easy to release the gem, among other things.

Docker is _not_ required to do development work on this gem.

## Using `docker-compose`

The `docker-compose` approach should link to enough of your networking configuration that you can release the gem.
However, you have to do some of the configuration yourself, because it's dependent on your host operating system.

First, build the image for whatever version of Ruby you need (typically either the earliest supported version or the latest):

```bash
RUBY_VERSION=3.2 docker-compose build
```

You can run a shell in a Docker container that pretty much should behave like a Debian distribution with:

```bash
docker-compose run --service-ports shell
```

(`--service-ports` exposes port 3000 so you can browse to the demo app on `localhost:3000`. If you just want to run a one-off command, or run the test suite, leave off the `--service-ports`.)

The following instructions work for an Ubuntu host, and will probably work for other common Linux distributions.

Add a `docker-compose.override.yml` in the local directory, that looks like this:

```docker-compose.yml
version: '3.3'

# https://blog.giovannidemizio.eu/2021/05/24/how-to-set-user-and-group-in-docker-compose/

services:
  shell:
    # You have to set the user and group for this process, because you're going to be
    # creating all kinds of files from inside the container, that need to persist
    # outside the container.
    # Change `1000:1000` to the user and default group of your laptop user.
    user: 1000:1000
    volumes:
      - /etc/passwd:/etc/passwd:ro
      - ~/.gem/credentials:/app/.gem/credentials:ro
      # $HOME here is your host computer's `~`, e.g. `/home/reid`.
      # `ssh` explicitly looks for its config in the home directory from `/etc/passwd`,
      # so the target for this has to look like your home directory on the host.
      - ~/.ssh:${HOME}/.ssh:ro
      - ${SSH_AUTH_SOCK}:/ssh-agent
    environment:
      - SSH_AUTH_SOCK=/ssh-agent
```

You may have to change the `1000:1000` to the user and group IDs of your laptop. You may also have to change the `version` parameter to match the version of the `docker-compose.yml` file.

Adapting the above `docker-compose.override.yml` for MacOS should be relatively straight-forward. Windows users, I'm afraid you're on your own. If you figure this out, a PR documenting how to do it would be most welcome.

The above doesn't allow you to run the system tests. To keep the image small, it doesn't include Chrome or any other browser.

There is an experimental `docker-compose-system-test.yml` file, that runs the `bootstrap_forms` docker container along with an off-the-shelf Selenium container. To start this configuration:

```bash
RUBY_VERSION=3.2 docker-compose -f docker-compose-system-test.yml -f docker-compose.override.yml up&
RUBY_VERSION=3.2 docker-compose -f docker-compose-system-test.yml -f docker-compose.override.yml exec shell /bin/bash
```

(Sometimes, on shutdown, the Rails server PID file isn't removed, and so the above will fail. `rm demo/tmp/pids/server.pid` will fix it.)

Once in the shell:

```bash
cd demo
bundle exec rails test:system
```

Note that this system test approach is highly experimental and has some rough edges. The docker compose file and/or steps to run system tests may change. The tests currently fail, because the files with which they're being compared were generated on a Mac, but the Docker containers are running Linux.

## Simple Dockerfile

This repository includes a `Dockerfile` to build an image with the minimum `bootstrap_form`-supported Ruby environment. To build the image:

```bash
docker build --tag bootstrap_form .
```

This builds an image called `bootstrap_form`. You can change that to any tag you wish. Just make sure you use the same tag name in the `docker run` command.

If you want to use a different Ruby version, or a smaller Linux distribution (although the distro may be missing tools you need):

```bash
docker build --build-arg "RUBY_VERSION=3.0" --build-arg "DISTRO=slim-buster" --tag bootstrap_form .
```

Then run the container you built with the shell, and create the bundle:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -it bootstrap_form /bin/bash
bundle install
```

You can run tests in the container as normal, with `rake test`.

(Some of that command line is need for Linux hosts, to run the container as the current user.)

One of the disadvantages of this approach is that you can't release the gem from here, because the Docker container doesn't have access to your SSH credentials, or the right user name, or perhaps other things needed to release a gem. But for simple testing, it works.

## Troubleshooting Docker

- With the above configuration, the gems are kept in `vendor/bundle` on your hosts, which is `$GEM_HOME` or `/app/vendor/bundle` in the running Docker container. If you're having permission problems when switching versions of Ruby or Rails, you can try `sudo rm -rf vendor/bundle` on the host, then run `BUNDLE_GEMFILES=gemfiles/7.0.gemfile bundle update` in the Docker container to re-install all the gems with the right permissions.
