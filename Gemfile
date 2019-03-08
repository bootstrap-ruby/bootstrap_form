source "http://rubygems.org"

gemspec

# Uncomment and change rails version for testing purposes
gem "rails", "~> 5.2.0"
# gem "rails", "~> 6.0.0.beta1"

group :development do
  gem "chandler", ">= 0.7.0"
  gem "htmlbeautifier"
  gem "rubocop", require: false
  gem "sass-rails"
  gem 'webpacker', '>= 4.0.0.rc.3'
end

group :test do
  # can relax version requirement for Rails 5.2.beta3+
  gem "minitest", "~> 5.10.3"

  gem "diffy"
  gem "equivalent-xml"
  gem "mocha"
  # sqlite3 1.4.0 breaks the test suite.
  # https://github.com/rails/rails/pull/35154
  gem "sqlite3", "~> 1.3.6"
  gem "timecop", "~> 0.7.1"
end
