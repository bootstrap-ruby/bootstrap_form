source "http://rubygems.org"

gemspec path: __dir__

# To test with different Rails versions, use the files in `./gemfiles`

group :development do
  gem "htmlbeautifier"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "webpacker"
end

group :test do
  gem "diffy"
  gem "equivalent-xml"
  gem "mocha"
  gem "sqlite3"
end

group :ci do
  gem "danger"
end
