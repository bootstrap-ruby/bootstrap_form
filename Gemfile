source "http://rubygems.org"

gemspec

# Uncomment and change rails version for testing purposes
# gem "rails", "~> 5.2.0"
gem "rails", "~> 6.0.0"

group :development do
  gem "chandler", ">= 0.7.0"
  gem "htmlbeautifier"
  gem "rubocop-rails", require: false
  gem "sassc-rails"
  gem "webpacker", ">= 4.0.0.rc.3"
end

group :test do
  # can relax version requirement for Rails 5.2.beta3+
  gem "minitest", "~> 5.10.3"

  gem "diffy"
  gem "equivalent-xml"
  gem "mocha"
  gem "sqlite3"
  gem "timecop", "~> 0.7.1"
end
