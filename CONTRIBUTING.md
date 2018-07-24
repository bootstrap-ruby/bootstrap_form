# Contributing

The release of Bootstrap 4 and Rails 5.1 have implications for the future
direction of `bootstrap_form`. Don't worry. We plan to move this gem forward to
Bootstrap 4 and to support Rails 5.1 and beyond. If you're thinking of
contributing to `bootstrap_form`, please read
[issue #361](https://github.com/bootstrap-ruby/bootstrap_form/issues/361).

Your comments are welcome.

Thanks so much for considering a contribution to bootstrap_form. We love pull requests!

Here's a quick guide for contributing:

### 1. Check if issue or feature is available to work on

Make sure no one else is working on the same issue or feature. Search the issues
and pull requests for anything that looks like the issue or feature you want to
address. If no one else is working on your issue or feature, carry on with the
following steps.

### 2. Fork the repo

Fork the project. Optionally, create a branch you want to work on.

### 3. Get it running locally

- Install the required dependencies with `bundle install`
- Run tests via: `bundle exec rake`

### 4. Hack away

- Try to keep your changes small. Consider making several smaller pull requests.
- Don't forget to add necessary tests.
- Update the README if necessary.
- Add a line to the CHANGELOG for your bug fix or feature.
- Read the [Coding Guidelines](#coding-guidelines) section and make sure that `rake lint` doesn't find any offences.

You may find using demo application useful for development and debugging.

- `cd demo`
- `rake db:schema:load`
- `rails s`
- Navigate to http://localhost:3000

### 5. Make a pull request

- If you have never made a pull request (PR) before, read this: https://help.github.com/articles/about-pull-requests/.
- When the PR is submitted, check if TravisCI ran all the tests successfully, and didn't raise any issues.

### 6. Done!

Somebody will shortly review your pull request and if everything is good will be
merged into the master branch. Eventually the gem will be published with your changes.

## Coding guidelines

This project uses [RuboCop](https://github.com/bbatsov/rubocop) to enforce standard Ruby coding
guidelines. Currently we run RuboCop's lint rules only, which check for readability issues
like indentation, ambiguity, and useless/unreachable code.

* Test that your contributions pass with `rake lint`
* The linter is also run as part of the full test suite with `bundle exec rake test`
* Note the Travis build will fail and your PR cannot be merged if the linter finds errors

---

Thanks to all the great contributors over the years: https://github.com/bootstrap-ruby/bootstrap_form/graphs/contributors
