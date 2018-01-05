# Contributing

The release of Bootstrap 4 and Rails 5.1 have implications
for the future direction of `bootstrap_form`.
Don't worry.
We plan to move this gem forward to Bootstrap 4
and to support Rails 5.1 and beyond.
If you're thinking of contributing to `bootstrap_form`,
please read [issue #361](https://github.com/bootstrap-ruby/rails-bootstrap-forms/issues/361).
Your comments are welcome.

Thanks so much for considering contributing to bootstrap_form!
We love pull requests!

Here's a quick guide for contributing:

1. Make sure no one else is working on the same issue or feature.
Search the issues and pull requests for anything
that looks like the issue or feature you want to address.
If no one else is working on your issue or feature,
carry on with the following steps.

2. Fork the repo.

2. Install the required dependencies.

```
bundle install
bundle exec appraisal install
```

3. Run the existing test suite:

```
$ bundle exec rake -f test/dummy/Rakefile db:create db:migrate RAILS_ENV=test
$ bundle exec appraisal rake test
```

4. Add tests for your change.

5. Add your changes and make your test(s) pass. Following the conventions you
see used in the source will increase the chance that your pull request is
accepted right away.

6. Update the README if necessary.

7. Add a line to the CHANGELOG for your bug fix or feature.

8. Push to your fork and submit a pull request.

## Contributors

Thanks to all the great contributors over the years: https://github.com/bootstrap-ruby/rails-bootstrap-forms/graphs/contributors
