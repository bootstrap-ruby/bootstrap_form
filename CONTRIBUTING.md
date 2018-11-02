# Contributing

Thanks so much for considering a contribution to bootstrap_form. We love pull requests!

We want everyone to feel welcome to contribute. We encourage respectful exchanges of ideas. We govern ourselves with the Contributor's Covenant [Code of Conduct](/CODE_OF_CONDUCT.md).

Here's a quick guide for contributing:

### 1. Check if issue or feature is available to work on

Make sure no one else is working on the same issue or feature. Search the issues
and pull requests for anything that looks like the issue or feature you want to
address. If no one else is working on your issue or feature, carry on with the
following steps.

### 2. Fork the repo

Fork the project. Optionally, create a branch you want to work on

### 3. Get it running locally

- Install the required dependencies with `bundle install`
- Run tests via: `bundle exec rake`

### 4. Hack away

- Try to keep your changes small. Consider making several smaller pull requests.
- Don't forget to add necessary tests.
- Update the README if necessary.
- Add a line to the CHANGELOG for your bug fix or feature.

You may find using demo application useful for development and debugging.

- `cd demo`
- `rake db:schema:load`
- `rails s`
- Navigate to http://localhost:3000

### 5. Make a Pull Request

- If you never done made a pull request before, read this: https://help.github.com/articles/about-pull-requests/
- When the PR is submitted, check if TravisCI ran all the tests successfully, and didn't raise any issues

### 6. Done!

Somebody will shortly review your pull request and if everything is good, it will be
merged into the master branch. Eventually the gem will be published with your changes.

---

Thanks to all the great contributors over the years: https://github.com/bootstrap-ruby/bootstrap_form/graphs/contributors
