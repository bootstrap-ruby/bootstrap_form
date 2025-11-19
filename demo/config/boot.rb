# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __dir__)

require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
# Only run the following line if we bootsnap is loaded, because we don't load it for the individual tests.
# The individual tests are the ones in `..`.
# They do load this file, for reasons.
require "bootsnap/setup" if Gem.loaded_specs.has_key?("bootsnap") # Speed up boot time by caching expensive operations.
