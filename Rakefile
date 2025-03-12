begin
  require 'bundler/setup'

  require 'bundler/gem_tasks'
  require "minitest/test_task"
  require 'rdoc/task'
  require 'rubocop/rake_task'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BootstrapForm'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

desc 'Run RuboCop checks'
RuboCop::RakeTask.new(:rubocop)

task default: %i[test rubocop:autocorrect]

namespace :test do
  desc "Run tests for all supported Rails versions, with current Ruby version"
  task :all do
    original_gemfile = ENV["BUNDLE_GEMFILE"]
    gemfiles = Dir.glob("gemfiles/*.gemfile").reject { |f| File.basename(f) == "common.gemfile" }
    gemfiles.each do |f|
      ENV["BUNDLE_GEMFILE"] = f
      system("bundle check") || system("bundle install")
      system("bundle exec rake test")
    end

    original_directory = Dir.pwd
    Dir.chdir("demo")
    ENV.delete("BUNDLE_GEMFILE")
    system("bundle check") || system("bundle install")
    system("bundle exec rake test:all")

  ensure
    original_gemfile.nil? ? ENV.delete("BUNDLE_GEMFILE") : ENV["BUNDLE_GEMFILE"] = original_gemfile
    Dir.chdir(original_directory) unless original_directory.nil?
  end
end
