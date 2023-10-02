# Contributing

Thanks so much for considering a contribution to bootstrap_form. We love pull requests!

We want everyone to feel welcome to contribute. We encourage respectful exchanges of ideas. We govern ourselves with the Contributor Covenant [Code of Conduct](/CODE_OF_CONDUCT.md).

There are a number of ways you can contribute to `bootstrap_form`:

- Fix a bug or add a new feature
- Add to the documentation
- Review pull requests

## Code Contributions

Here's a quick guide for code contributions:

### 1. Check if issue or feature is available to work on

Make sure no one else is working on the same issue or feature. Search the issues
and pull requests for anything that looks like the issue or feature you want to
address. If no one else is working on your issue or feature, carry on with the
following steps.

### 2. (Optional) Create an issue, and wait a few days for someone to respond

If you create an issue for your feature request or bug, it gives the maintainers a chance to comment on your ideas before you invest a lot of work on a contribution. It may save you some re-work compared to simply submitting a pull request. It's up to you whether you submit an issue.

### 3. Fork the repo

Fork the project. Optionally, create a branch you want to work on.

### 4. Get it running locally

- Install the required dependencies with `bundle install`
- Run tests via: `bundle exec rake`

### 5. Hack away

- Try to keep your changes small. Consider making several smaller pull requests if your changes are extensive.
- Don't forget to add necessary tests.
- Update the README if necessary.
- Add a line to the CHANGELOG for your bug fix or feature.
- Read the [Coding Guidelines](#coding-guidelines) section and make sure that `rake lint` doesn't find any offences.

You may find the [demo application](#the-demo-application) useful for development and debugging.

### 6. Make a pull request

- If you've never made a pull request (PR) before, read [this](https://help.github.com/articles/about-pull-requests/).
- If your PR fixes an issues, be sure to put "Fixes #nnn" in the description of the PR (where `nnn` is the issue number). Github will automatically close the issue when the PR is merged.
- When the PR is submitted, check if GitHub Actions ran all the tests successfully, and didn't raise any issues.

### 7. Done

Somebody will shortly review your pull request and if everything is good, it will be
merged into the main branch. Eventually the gem will be published with your changes.

### Coding guidelines

This project uses [RuboCop](https://github.com/bbatsov/rubocop) to enforce standard Ruby coding
guidelines.

- Test that your contribution passes with `rake rubocop`.
- RuboCop is also run as part of the full test suite with `bundle exec rake`.
- Note the Travis build will fail and your PR cannot be merged if RuboCop finds offences.

Note that most editors have plugins to run RuboCop as you type, or when you save a file. You may find it well worth your time to install and configure the RuboCop plugin for your editor. Read the [RuboCop documentation](https://rubocop.readthedocs.io/en/latest/integration_with_other_tools/).

### Supported Versions of Ruby and Rails

The goal of `bootstrap_form` is to support all versions of Rails currently supported for bug fixes and security issues. We do not test against versions supported for severe security issues. We test against the minimum [version of Ruby required](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions) for those versions of Rails.

The Ruby on Rails support policy is [here](https://guides.rubyonrails.org/maintenance_policy.html).

### Developing with Docker

This repository offers experimental support support for a couple of ways to develop using Docker, if you're interested:

- Using `docker-compose`. This way is less tested, and is an attempt to make the Docker container a more complete environment where you can conveniently develop and release the gem.
- Using just a simple Dockerfile. This way works for simple testing, but doesn't make it easy to release the gem, among other things.

Docker is _not_ required to work on this gem.

#### Using `docker-compose`

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

#### Simple Dockerfile

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

#### Troubleshooting Docker

- With the above configuration, the gems are kept in `vendor/bundle` on your hosts, which is `$GEM_HOME` or `/app/vendor/bundle` in the running Docker container. If you're having permission problems when switching versions of Ruby or Rails, you can try `sudo rm -rf vendor/bundle` on the host, then run `BUNDLE_GEMFILES=gemfiles/7.0.gemfile bundle update` in the Docker container to re-install all the gems with the right permissions.

### The Demo Application

There is a demo app in this repository. It shows some of the features of `bootstrap_form`, and provides a base on which to build ad-hoc testing, if you need it.

Currently, the demo app is only set up to run for Rails 7, due to the variety of ways to include CSS and JavaScript in a modern Rails application.
To run the demo app, set up the database and run the server:

```bash
cd demo
bundle
rails db:setup
dev
```

To run the demo app in the Docker container:

```bash
docker run --volume "$PWD:/app" --user $UID:`grep ^$USERNAME /etc/passwd | cut -d: -f4` -p 3000:3000 -it bootstrap_form /bin/bash
cd demo
bundle
rails db:setup
dev
```

You'll see errors in the browser console about duplicate ids. This is expected, since the demo app has many forms with the same fields in them. Something we can fix in the future, perhaps.

To use other supported versions of Rails, you will need to create a `Gemfile` for the Rails version. Then, change the `export BUNDLE_GEMFILE...` line to your gem file. Finally, figure out how to include the assets.

If you need to run the Rails server separately, for example, to debug the server, you _must_ run it like this:

```sh
bundle exec rails s -b 0.0.0.0
```

If you run just `rails` or even `bin/rails`, the `sprockets-rails` gem won't load and you'll either get error messages, or the assets  won't be available to the demo app. At the moment it's a mystery why. PRs to fix this are welcome.

Please try to keep the checked-in `.ruby-version` set to the oldest supported version of Ruby. You're welcome and encouraged to try the demo app with other Ruby versions. Just don't check in the `.ruby-version` to GitHub.

For the record, the demo app is set up as if the Rails app had been created with:

```sh
rails new --skip-hotwire -d sqlite --edge -j esbuild -c bootstrap .
```

This means it's using `esbuild` to pre-process the JavaScript and (S)CSS, and that it's using [`jsbunding-rails`](https://github.com/rails/jsbundling-rails) and [`cssbundling-rails`](https://github.com/rails/cssbundling-rails) to put the assets in `app/assets/builds`, before the Sprockets assets pipeline serves them in development, or pre-compiles them in production.

## Documentation Contributions

Contributions to documentation are always welcome. Even fixing one typo improves the quality of `bootstrap_form`. To make a documentation contribution, follow steps 1-3 of Code Contributions, then make the documentation changes, then make the pull request (step 6 of Code Contributions).

If you put `[ci skip]` in the commit message of the most recent commit of the PR, you'll be a good citizen by not causing our CI pipeline to run all the tests when it's not necessary.

## Reviewing Pull Requests

We are an entirely volunteer project. Sometimes it's hard for people to find the time to review pull requests. You can help! If you see a pull request that's waiting to be merged, it could be because no one has reviewed it yet. Your review could help move the pull request forward to be merged.

---

Thanks to all the [great contributors](https://github.com/bootstrap-ruby/bootstrap_form/graphs/contributors) over the years.

## Troubleshooting

### Models and Database Tables

`bootstrap_form` needs a few models and tables to support testing. It appears that the necessary tables were created via the `demo/db/schema.rb` file. To support `rich_text_area`, Rails 6 creates some migrations. These migrations had to be run in the existing database (not an empty one) to create a new `schema.rb` that creates the `bootstrap_form` test tables, and the tables needed by Rails 6. The `schema.rb` file was checked in to GitHub, but the migrations were not.

In the future, any new Rails functionality that creates tables would likely have to be prepared the same way:

```bash
cd demo
rails db:setup # create the databases from `schema.rb`
rails db:migrate # add the new tables and create a new `schema.rb`
```

### RuboCop

When you push a branch, RuboCop checks may fail, but locally you can't reproduce the failure. This may be because you're using a different version of RuboCop locally. When you push, the RuboCop tests use the currently available version of RuboCop. If you've been working on the branch for a while, it's likely you have a `Gemfile.lock` that specifies an older version of RuboCop.

The first thing to try is to update your `Gemfile.lock` locally:

```bash
bundle update
```

Or, if you really want to minimize your work:

```bash
bundle update --conservative rubocop
```

This should enable you to reproduce the RuboCop failures locally, and then you can fix them.
