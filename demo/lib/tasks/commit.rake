# frozen_string_literal: true

desc <<~DESC
  Commit changed files, if any. Meant to be used in CI to commit automatically created files
  (e.g. screenshots).
DESC
task :commit do # rubocop:disable Rails/RakeEnvironment
  msg = <<~MSG
    [skip ci] Changed in CI
    Please review the changes in the files in this commit
    carefully, as they were automatically generated during CI.
    Run `git pull` to bring the changes into your local branch.
    Then, if you do not want the changes, run `git revert HEAD`.
  MSG
  system("git config user.name github-actions")
  system("git config user.email github-actions@github.com")
  system("git diff --exit-code -s || git commit --all -m '#{msg}' && git push")
end
