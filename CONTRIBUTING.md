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

When you create or update a pull request, GitHub automatically runs tests that generate the screenshots in the [`README.md`](/README.md). If any of the screenshots change, GitHub will add an additional commit to your branch, with the updated screenshots.

Normally, the screenshots should _not_ change. If the screenshots changed, please review them _carefully_. Some clear reasons why you would want to keep the changed screenshots:

- Your PR was fixing behaviour that was wrong in the screenshot.
- You added new examples in the documentation, so there are new screenshots.
- A change to the images used by GitHub in their actions changes the behaviour of Chrome, although if you think it's this you should probably prepare a separate PR that _only_ updates the screenshots, so it's clear what the change is and why we're making the change.

Unless you have one of the above reasons, or you have a good explanation for why the screenshots have changed with your PR, you need to get rid of the changed screenshots (i.e. revert the last commit) and fix your PR so the screenshots don't change. (The reason you should revert the commit with the screenshots is so that the next time you push, GitHub will compare against the original screenshots, not the ones changed by your previous push.) Here's how to get rid of the changed screenshots:

```bash
git pull # to bring the additional commit to your local branch.
git revert HEAD # to remove the changes.
```

Then fix the code and push your branch again.

If the change was intended, a comment in the PR explaing why the change is expected would be very much appreciated. More than appreciated. It will avoid us having to ask you for an explanation.

You can run the tests that generate the screenshots locally, but unless your environment is very much like the GitHub CI environment -- Ubuntu running Chrome with default fonts -- all the screenshots will be reported as having changed. To generate the screenshots:

```bash
cd demo
bundle exec rails test:all # or test:system
```

The [Docker development environment](#using-docker compose) appears to generate screenshots that are the same as what GitHub generates.

Finally, maintainers may sometimes push changes directly to `main` or use other workflows to update the code. If pushing to `main` generates a commit for screenshot changes, please consider reverting your change immediately by executing the above `pull` and `revert` and another `push`, for the sanity of users who are using the edge (`main` branch) version of the gem. At any rate, review the changes promptly and use your judgement.

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

This repository offers experimental support for development using Docker. Docker is _not_ required to do development work on this gem.

One advantage of the Docker environment is that it allows you to generate and compare the screenshots with the expected screenshots in the repo. It also allows you to develop in an environment that is isolated from your own computer's set-up, so there's less risk of breaking other things you might be doing with your computer.

If you're intested in trying the Docker approach, read the [documentation](DOCKER.md).

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
