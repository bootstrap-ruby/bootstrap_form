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
  s.summary     = "Rails form builder that makes it easy to style forms using Twitter Bootstrap 2.0"
  s.description = "bootstrap_form is a rails form builder that makes it super easy to create beautiful-looking forms using Twitter Bootstrap 2.0"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rails", "~> 4.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "timecop", "~> 0.3.5"
end
