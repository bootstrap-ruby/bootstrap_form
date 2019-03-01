begin
  require 'bundler/setup'
  require 'rubocop/rake_task'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BootstrapForm'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

# This automatically updates GitHub Releases whenever we `rake release` the gem
task "release:rubygem_push" do
  require "chandler/tasks"
  Rake.application.invoke_task("chandler:push")
end

desc 'Run RuboCop checks'
RuboCop::RakeTask.new(:rubocop)

task default: %i[test rubocop]
