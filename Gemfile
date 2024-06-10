gems = "#{__dir__}/gemfiles/common.gemfile"
eval File.read(gems), binding, gems # rubocop: disable Security/Eval

require "#{__dir__}/lib/bootstrap_form/version"

gem "rails", BootstrapForm::REQUIRED_RAILS_VERSION
gem "sprockets-rails", require: "sprockets/railtie"

gem "bigdecimal" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
gem "drb" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
gem "mutex_m" if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.4.0")
gem "sqlite3", "~> 1.4"
