lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bootstrap_form/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap_form"
  s.version     = BootstrapForm::VERSION
  s.authors     = ["Stephen Potenza", "Carlos Lopes"]
  s.email       = ["potenza@gmail.com", "carlos.el.lopes@gmail.com"]
  s.homepage    = "https://github.com/bootstrap-ruby/rails-bootstrap-forms"
  s.summary     = "Rails form builder that makes it easy to style forms using "\
                  "Bootstrap 4"
  s.description = "bootstrap_form is a rails form builder that makes it super "\
                  "easy to create beautiful-looking forms using Bootstrap 4"
  s.license     = "MIT"

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.bindir = "exe"

  s.add_development_dependency "appraisal"
  s.add_development_dependency "diffy"
  s.add_development_dependency "equivalent-xml"
  s.add_development_dependency "mime-types", "~> 2.6.2"
  s.add_development_dependency "mocha"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "rails", ">= 4.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "timecop", "~> 0.7.1"
end
