lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bootstrap_form/version"

REQUIRED_RAILS_VERSION = ">= 5.2".freeze

Gem::Specification.new do |s|
  s.name        = "bootstrap_form"
  s.version     = BootstrapForm::VERSION
  s.authors     = ["Stephen Potenza", "Carlos Lopes"]
  s.email       = ["potenza@gmail.com", "carlos.el.lopes@gmail.com"]
  s.homepage    = "https://github.com/bootstrap-ruby/bootstrap_form"
  s.summary     = "Rails form builder that makes it easy to style forms using "\
                  "Bootstrap 5"
  s.description = "bootstrap_form is a rails form builder that makes it super "\
                  "easy to create beautiful-looking forms using Bootstrap 5"
  s.license     = "MIT"
  s.metadata    = { "rubygems_mfa_required" => "true" }

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end

  s.bindir        = "exe"
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.7"

  s.add_dependency("actionpack", REQUIRED_RAILS_VERSION)
  s.add_dependency("activemodel", REQUIRED_RAILS_VERSION)
end
