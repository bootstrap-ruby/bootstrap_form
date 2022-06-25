# Releasing

Follow these steps to release a new version of bootstrap_form to rubygems.org.

## Prerequisites

* You must have commit rights to the bootstrap_form repository.
* You must have push rights for the bootstrap_form gem on rubygems.org.
* You must be using a Ruby version that is not end-of-life.

## How to release

1. Run `BUNDLE_GEMFILE=gemfiles/7.0.gemfile bundle update` to make sure that you have all the gems necessary for testing and releasing.
2. **Ensure the tests are passing by running `BUNDLE_GEMFILE=gemfiles/7.0.gemfile bundle update`.** (Currently this step shows a lot of warnings about method redefinitions, but otherwise everything must be green before release.)
3. Determine which would be the correct next version number according to [semver](http://semver.org/).
4. Update the version in `./lib/bootstrap_form/version.rb`.
5. Update the GitHub diff links at the beginning of `CHANGELOG.md` (The pattern should be obvious when you look at them).
6. Update the installation instructions in `README.md` to use the new version.
7. Commit the CHANGELOG and version changes in a single commit; the message should be "Preparing vX.Y.Z" where `X.Y.Z` is the version being released.
8. Run `bundle exec rake release`; this will tag, push to GitHub, and publish to rubygems.org.
