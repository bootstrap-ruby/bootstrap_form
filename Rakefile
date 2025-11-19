begin
  require "bundler/setup"
  require "bundler/gem_tasks"
  require "minitest/test_task"
  require "rdoc/task"
  require "rubocop/rake_task"
rescue LoadError => e
  puts "You must run `bundle install` to run rake tasks (#{e.message})"
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "BootstrapForm"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

Minitest::TestTask.create(:test) do |t|
  t.warning = true
  t.test_globs = ["test/**/*_test.rb"]
end

desc "Run RuboCop checks"
RuboCop::RakeTask.new(:rubocop)

task default: %i[test rubocop:autocorrect]

namespace :test do
  desc "Run tests for all supported Rails versions, with current Ruby version"
  task :all do
    gemfiles.each do |gemfile|
      system("BUNDLE_GEMFILE=#{gemfile} rake test")
    end

    Dir.chdir("demo")
    system("BUNDLE_GEMFILE= rake test:all")
  end
end

desc "Update gem .lock files e.g. for changed Ruby version"
task :update_gemfile_locks do
  gemfiles.append("Gemfile").each do |gemfile|
    system("BUNDLE_GEMFILE=#{gemfile} bundle update --bundler")
  end
end

def gemfiles = Dir.glob("gemfiles/*.gemfile").reject { |f| File.basename(f) == "common.gemfile" }
