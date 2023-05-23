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
