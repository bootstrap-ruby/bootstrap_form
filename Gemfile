source "http://rubygems.org"

gemspec

# Uncomment and change rails version for testing purposes
# gem "rails", "~> 5.2.0"
gem "rails", "~> 6.0.0"
# gem "rails", git: "https://github.com/rails/rails.git"

group :development do
  gem "chandler", ">= 0.7.0"
  gem "htmlbeautifier"
  gem "rubocop-rails", require: false
  gem "sassc-rails"
  gem "webpacker"
end

group :test do
  # can relax version requirement for Rails 5.2.beta3+
  gem "diffy"
  gem "equivalent-xml"
  gem "mocha"
  gem "sqlite3"
end
