# Test examples that appear in the documentation.
# The expected string should be what you can cut and paste directly into
# the documentation.
require_relative 'test_helper'

class DocumentationTest < ActionView::TestCase
  include BootstrapForm::Helper

  def setup
    setup_test_fixture
  end

  # Tests for field types that have explicit labels, and therefore are
  # potentially affected by the lack of default DOM ids from `form_with`.

  if ::Rails::VERSION::STRING >= '5.2'
    test "form_with skip_default_ids example" do
      expected = <<-HTML.strip_heredoc
      <form role="form" action="/users" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="email">Email</label>
          <input id="email" class="form-control" type="email" value="steve@example.com" name="user[email]" />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input id="password" class="form-control" type="password" name="user[password]" />
          <span class="form-text text-muted">A good password should be at least six characters long</span>
        </div>
        <div class="form-check">
          <label for="remember" class="form-check-label">
          <input name="user[remember_me]" type="hidden" value="0" />
          <input id="remember_me" class="form-check-input" type="checkbox" value="1" name="user[remember_me]" /> Remember me</label>
        </div>
        <input id="log_in" type="submit" name="commit" value="Log In" class="btn btn-secondary" data-disable-with="Log In" />
      </form>
      HTML

      actual = bootstrap_form_with(model: @user, local: true, skip_default_ids: false) do |f|
        f.email_field(:email)
         .concat(f.password_field(:password))
         .concat(f.check_box(:remember_me))
         .concat(f.submit("Log In"))
      end

      assert_equivalent_xml expected, actual
    end
  end

  if ::Rails::VERSION::STRING >= '5.1'
    test "initial form_with example" do
      expected = <<-HTML.strip_heredoc
      <form role="form" action="/users" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <input class="form-control" type="email" value="steve@example.com" name="user[email]" />
        </div>
        <div class="form-group">
          <label for="user_password">Password</label>
          <input class="form-control" type="password" name="user[password]" />
          <small class="form-text text-muted">A good password should be at least six characters long</small>
        </div>
        <div class="form-check">
          <label class="form-check-label" for="user_remember_me">
          <input name="user[remember_me]" type="hidden" value="0" />
          <input class="form-check-input" type="checkbox" value="1" name="user[remember_me]" /> Remember me</label>
        </div>
        <input type="submit" name="commit" value="Log In" class="btn btn-secondary" data-disable-with="Log In" />
      </form>
      HTML

      actual = bootstrap_form_with(model: @user, local: true) do |f|
        f.email_field(:email)
         .concat(f.password_field(:password))
         .concat(f.check_box(:remember_me))
         .concat(f.submit("Log In"))
      end

      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected), actual
    end

    test "form_with no model example" do
      expected = <<-HTML.strip_heredoc
      <form role="form" action="/subscribe" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="email">Email</label>
          <input value="name@example.com" class="form-control" type="email" name="email" />
        </div>
        <input type="submit" name="commit" value="Save " class="btn btn-secondary" data-disable-with="Save " />
      </form>
      HTML

      actual = bootstrap_form_with(url: '/subscribe', local: true) do |f|
        f.email_field(:email, value: 'name@example.com')
         .concat(f.submit)
      end

      assert_equivalent_xml expected, actual
    end

    test "form_with explicit id example" do
      expected = <<-HTML.strip_heredoc
      <form role="form" action="/users" accept-charset="UTF-8" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <input class="form-control" type="email" value="steve@example.com" name="user[email]" />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input id="password" class="form-control" type="password" name="user[password]" />
          <small class="form-text text-muted">A good password should be at least six characters long</small>
        </div>
        <input type="submit" name="commit" value="Log In" class="btn btn-secondary" data-disable-with="Log In" />
      </form>
      HTML

      # Removed this from above pending #357
      # <div class="form-check">
      #   <label for="remember" class="form-check-label">
      #   <input name="user[remember_me]" type="hidden" value="0" />
      #   <input id="remember" class="form-check-input" type="checkbox" value="1" name="user[remember_me]" /> Remember me</label>
      # </div>

      actual = bootstrap_form_with(model: @user, local: true) do |f|
        f.email_field(:email)
         .concat(f.password_field(:password, id: :password))
         .concat(f.submit("Log In"))
      end
      #  .concat(f.check_box(:remember_me, id: :remember)) pending #357 place above "Log In"

      assert_equivalent_xml expected, actual
    end
  end
end
