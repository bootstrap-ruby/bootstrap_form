# Working With Docker

This repository offers experimental support support for developing using Docker, if you're interested. Docker is _not_ required to work on this gem.

The `docker compose` approach should link to enough of your networking configuration that you can release the gem.
However, you have to do some of the configuration yourself, because it's dependent on your host operating system.

## Set-Up

Put your personal and OS-specific configuration in a `compose.override.yml` file.

The following instructions work for an Ubuntu host, and will probably work for other common Linux distributions. Add a `compose.override.yml` in the local directory, that looks like this:

```compose.override.yml
# https://blog.giovannidemizio.eu/2021/05/24/how-to-set-user-and-group-in-docker compose/

services:
  web:
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

You may have to change the `1000:1000` to the user and group IDs of your laptop. You may also have to change the `version` parameter to match the version of the `docker compose.yml` file.

Adapting the above `compose.override.yml` for MacOS should be relatively straight-forward. Windows users, I'm afraid you're on your own. If you figure this out, a PR documenting how to do it would be most welcome.

## Running

Start the containers:

```bash
docker compose up -d
```

You may need to install or update the gems:

```bash
docker compose exec web bundle install
```

To get a shell in the container:

```bash
docker compose exec web /bin/bash
```

Once in the shell, run tests:

```bash
bundle exec rake test
```

Run the demo app and browse to it:

```bash
cd demo
bin/dev
```

On the host, not the Docker container, get the port number(s) you can use in the browser to access the test app running in the Docker container:

```bash
docker compose port web 3001 | cut -d: -f 2 # Browser
docker compose port web 7900 | cut -d: -f 2 # To watch the browser execute system tests.
```

Browse to `localhost:<port number from above>`.

Run system tests:

```bash
cd demo
bundle exec rails test:system
```

Note that this system test approach is highly experimental and has some rough edges. The docker compose file and/or steps to run system tests may change.

## Troubleshooting Docker

- With the above configuration, the gems are kept in `vendor/bundle` on your hosts, which is `$GEM_HOME` or `/app/vendor/bundle` in the running Docker container. If you're having permission problems when switching versions of Ruby or Rails, you can try `sudo rm -rf vendor/bundle` on the host, then run `BUNDLE_GEMFILES=gemfiles/7.0.gemfile bundle update` in the Docker container to re-install all the gems with the right permissions.
- Sometimes, on shutdown, the Rails server PID file isn't removed, and so the above will fail. `rm demo/tmp/pids/server.pid` will fix it.

