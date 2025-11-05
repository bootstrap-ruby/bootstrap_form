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
    original_gemfile = ENV.fetch("BUNDLE_GEMFILE", nil)
    gemfiles = Dir.glob("gemfiles/*.gemfile").reject { |f| File.basename(f) == "common.gemfile" }
    gemfiles.each do |f|
      ENV["BUNDLE_GEMFILE"] = f
      system("bundle update --bundler")
      system("bundle check") || system("bundle install")
      system("rake test")
    end

    original_directory = Dir.pwd
    Dir.chdir("demo")
    ENV.delete("BUNDLE_GEMFILE")
    system("bundle update --bundler")
    system("bundle check") || system("bundle install")
    system("rake test:all")
  ensure
    original_gemfile.nil? ? ENV.delete("BUNDLE_GEMFILE") : ENV["BUNDLE_GEMFILE"] = original_gemfile
    Dir.chdir(original_directory) unless original_directory.nil?
  end
end
