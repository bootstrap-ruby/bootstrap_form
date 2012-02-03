$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap_form/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap_form"
  s.version     = BootstrapForm::VERSION
  s.authors     = ["Stephen Potenza"]
  s.email       = ["potenza@gmail.com"]
  s.homepage    = "http://github.com/potenza/bootstrap_form"
  s.summary     = "Rails 3.1+ form builder that makes it easy to style forms with Twitter Bootstrap 2.0"
  s.description = "Rails 3.1+ form builder that makes it easy to style forms with Twitter Bootstrap 2.0"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1"

  s.add_development_dependency "sqlite3"
end
