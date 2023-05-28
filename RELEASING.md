# Releasing

Follow these steps to release a new version of bootstrap_form to rubygems.org.

## Prerequisites

* You must have commit rights to the bootstrap_form repository.
* You must have push rights for the bootstrap_form gem on rubygems.org.
* You must be using a Ruby version that is not end-of-life.

## How to release

1. Make sure that you have all the gems necessary for testing and releasing.

       BUNDLE_GEMFILE=gemfiles/7.0.gemfile bundle update

2. **Ensure the tests are passing by running the tests**

   (There should be no errors or warnings.)

       BUNDLE_GEMFILE=gemfiles/7.0.gemfile bundle exec rake test

3. **Ensure the demo tests are passing by running**

       cd demo
       bundle update
       bundle exec rake test:all
       cd -

4. Determine which would be the correct next version number according to [semver](http://semver.org/).
5. Update the version in `./lib/bootstrap_form/version.rb`.
6. Update the GitHub diff links at the beginning of `CHANGELOG.md` (The pattern should be obvious when you look at them).
7. Update the installation instructions in `README.md` to use the new version.
8. Commit the CHANGELOG and version changes in a single commit; the message should be "Preparing vX.Y.Z" where `X.Y.Z` is the version being released.
9. Run `bundle exec rake release`; this will tag, push to GitHub, and publish to rubygems.org.
10. Go to https://github.com/bootstrap-ruby/bootstrap_form/releases and create the new release and add release notes by clicking the "Generate release notes" button.
    Add the link of closed issues from CHANGELOG.
    Group the commits in sections:
    * ### New features
    * ### Bugfixes
    * ### Performance
    * ### Documentation
    * ### Development
