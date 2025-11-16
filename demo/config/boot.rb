ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
# Only run the following line if we bootsnap is loaded, because we don't load it for the individual tests.
# The individual tests are the ones in `..`.
# They do load this file, for reasons.
require "bootsnap/setup" if Gem.loaded_specs.has_key?("bootsnap") # Speed up boot time by caching expensive operations.
