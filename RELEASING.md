# Releasing

Follow these steps to release a new version of bootstrap_form to rubygems.org.

## Prerequisites

* You must have commit rights to the bootstrap_form repository.
* You must have push rights for the bootstrap_form gem on rubygems.org.
* You must be using Ruby >= 2.2.
* Your `~/.netrc` must be configured with your GitHub credentials, [as explained here](https://github.com/mattbrictson/chandler#option-1---netrc).

## How to release

1. Run `bundle install` to make sure that you have all the gems necessary for testing and releasing.
2.  **Ensure the tests are passing by running `bundle exec rake`.**
3. Determine which would be the correct next version number according to [semver](http://semver.org/).
4. Update the version in `./lib/bootstrap_form/version.rb`.
5. Update the `CHANGELOG.md`:
    * Rename the Pending Release section to `[version][] (date)` with appropriate values `version` and `date`
    * Remove the "Your contribution here!" bullets from the release notes
    * Add a new Pending Release section at the top of the file with a template for contributors to fill in, including "Your contribution here!" bullets
    * Add the appropriate GitHub diff links to the footer of the document
6. Update the installation instructions in `README.md` to use the new version.
7. Commit the CHANGELOG and version changes in a single commit; the message should be "Preparing vX.Y.Z" where `X.Y.Z` is the version being released.
8. Run `bundle exec rake release`; this will tag, push to GitHub, publish to rubygems.org, and upload the latest CHANGELOG entry to the [GitHub releases page](https://github.com/bootstrap-ruby/bootstrap_form/releases).
