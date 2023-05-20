gems = "#{__dir__}/gemfiles/common.gemfile"
eval File.read(gems), binding, gems # rubocop: disable Security/Eval

require "#{__dir__}/lib/bootstrap_form/version"

gem "rails", BootstrapForm::REQUIRED_RAILS_VERSION
gem "sprockets-rails", require: "sprockets/railtie"
