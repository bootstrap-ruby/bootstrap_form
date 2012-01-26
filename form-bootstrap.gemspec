$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "form-bootstrap/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "form-bootstrap"
  s.version     = FormBootstrap::VERSION
  s.authors     = ["Stephen Potenza"]
  s.email       = ["potenza@gmail.com"]
  s.homepage    = "http://github.com/potenza/form-bootstrap"
  s.summary     = "Rails 3.1+ FormBuilder for Twitter Bootstrap."
  s.description = "Provides a builder that makes it super easy to take advantage of Twitter Bootstrap forms styles."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.3"

  s.add_development_dependency "sqlite3"
end
