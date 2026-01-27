# Releasing

Follow these steps to release a new version of bootstrap_form to rubygems.org.

## Prerequisites

* You must have commit rights to the bootstrap_form repository.
* You must have push rights for the bootstrap_form gem on rubygems.org.
* You must be using a Ruby version that is not end-of-life.

## How to release

In the `bootstrap_form` repository (not a fork):

1. Determine which would be the correct next version number according to [semver](http://semver.org/).
2. Update the version in `./lib/bootstrap_form/version.rb`.
3. Make sure that you have all the gems necessary for testing and releasing.

       BUNDLE_GEMFILE=gemfiles/7.2.gemfile bundle update

4. **Ensure the tests are passing by running the tests**

   (There should be no errors or warnings.)

       bundle exec rake test:all

   You will have failures in the system tests unless you're running on Linux. Chrome on each operating system renders slightly differently.

7. Update the installation instructions in `README.md` to use the new version.
8. Commit the CHANGELOG and version changes in a single commit; the message should be "Preparing vX.Y.Z" where `X.Y.Z` is the version being released.
8. If you did the above on a branch, merge it to `main`.
9. Tag, push to GitHub, and publish to rubygems.org:

       bundle exec rake release

10. Go to https://github.com/bootstrap-ruby/bootstrap_form/releases and create the new release and add release notes by clicking the "Generate release notes" button.
    Add the link of closed issues from CHANGELOG.
    Group the commits in sections:

    * ### New features
    * ### Bugfixes
    * ### Performance
    * ### Documentation
    * ### Development
