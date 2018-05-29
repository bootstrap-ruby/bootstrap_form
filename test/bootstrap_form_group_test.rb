require_relative "./test_helper"

class BootstrapFormGroupTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "changing the label text via the label option parameter" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email Address</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, label: 'Email Address')
  end

  test "changing the label text via the html_options label hash" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email Address</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, label: {text: 'Email Address'})
  end

  test "hiding a label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="sr-only required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, hide_label: true)
  end

  test "adding a custom label class via the label_class parameter" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="btn required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, label_class: 'btn')
  end

  test "adding a custom label class via the html_options label hash" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="btn required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, label: {class: 'btn'})
  end

  test "adding a custom label and changing the label text via the html_options label hash" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="btn required" for="user_email">Email Address</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, label: {class: 'btn', text: "Email Address"})
  end

  test "skipping a label" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, skip_label: true)
  end

  test "preventing a label from having the required class" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, skip_required: true)
  end

  test "label as placeholder" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="sr-only required" for="user_email">Email</label>
        <input class="form-control" id="user_email" placeholder="Email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, label_as_placeholder: true)
  end

  test "adding prepend text" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <div class="input-group">
          <div class="input-group-prepend">
            <span class="input-group-text">@</span>
          </div>
          <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, prepend: '@')
  end

  test "adding append text" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <div class="input-group">
          <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
          <div class="input-group-append">
            <span class="input-group-text">.00</span>
          </div>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, append: '.00')
  end

  test "append and prepend button" do
    prefix = %{<div class="form-group"><label class="required" for="user_email">Email</label><div class="input-group">}
    field = %{<input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />}
    button_prepend = %{<div class="input-group-prepend"><a class="btn btn-secondary" href="#">Click</a></div>}
    button_append = %{<div class="input-group-append"><a class="btn btn-secondary" href="#">Click</a></div>}
    suffix = %{</div></div>}
    after_button = prefix + field + button_append + suffix
    before_button = prefix + button_prepend + field + suffix
    both_button = prefix + button_prepend + field + button_append  + suffix
    button_src = link_to("Click", "#", class: "btn btn-secondary")
    assert_equivalent_xml after_button, @builder.text_field(:email, append: button_src)
    assert_equivalent_xml before_button, @builder.text_field(:email, prepend: button_src)
    assert_equivalent_xml both_button, @builder.text_field(:email, append: button_src, prepend: button_src)
  end

  test "adding both prepend and append text" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <div class="input-group">
          <div class="input-group-prepend">
            <span class="input-group-text">$</div>
          </div>
          <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
          <div class="input-group-append">
            <span class="input-group-text">.00</span>
          </div>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, prepend: '$', append: '.00')
  end

  test "adding both prepend and append text with validation error" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text">$</div>
            </div>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            <div class="input-group-append">
              <span class="input-group-text">.00</span>
            </div>
            <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</span>
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.text_field :email, prepend: '$', append: '.00' }
  end

  test "help messages for default forms" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        <small class="form-text text-muted">This is required</small>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, help: 'This is required')
  end

  test "help messages for horizontal forms" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
          <small class="form-text text-muted">This is required</small>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @horizontal_builder.text_field(:email, help: "This is required")
  end

  test "help messages to look up I18n automatically" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="text" value="secret" />
        <small class="form-text text-muted">A good password should be at least six characters long</small>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:password)
  end

  test "help messages to look up I18n automatically using HTML key" do
    I18n.backend.store_translations(:en, activerecord: {
      help: {
        user: {
          password: {
            html: 'A <strong>good</strong> password should be at least six characters long'
          }
        }
      }
    })

    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="text" value="secret" />
        <small class="form-text text-muted">A <strong>good</strong> password should be at least six characters long</small>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:password)
  end

  test "help messages to warn about deprecated I18n key" do
    super_user = SuperUser.new(@user.attributes)
    builder = BootstrapForm::FormBuilder.new(:super_user, super_user, self, {})

    I18n.backend.store_translations(:en, activerecord: {
      help: {
        superuser: {
          password: 'A good password should be at least six characters long'
        }
      }
    })

    builder.stubs(:warn).returns(true)
    builder.expects(:warn).at_least_once

    builder.password_field(:password)
  end

  test "help messages to ignore translation when user disables help" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_password">Password</label>
        <input class="form-control" id="user_password" name="user[password]" type="text" value="secret" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:password, help: false)
  end

  test "form_group creates a valid structure and allows arbitrary html to be added via a block" do
    output = @horizontal_builder.form_group :nil, label: { text: 'Foo' } do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2" for="user_nil">Foo</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "form_group adds a spacer when no label exists for a horizontal form" do
    output = @horizontal_builder.form_group do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <div class="col-sm-10 offset-sm-2">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "form_group renders the label correctly" do
    output = @horizontal_builder.form_group :email, label: { text: 'Custom Control' } do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="user_email">Custom Control</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "form_group accepts class thorugh options hash" do
    output = @horizontal_builder.form_group :email, class: "foo" do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group foo row">
        <div class="col-sm-10 offset-sm-2">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "form_group accepts class thorugh options hash without needing a name" do
    output = @horizontal_builder.form_group class: "foo" do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group foo row">
        <div class="col-sm-10 offset-sm-2">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "form_group horizontal lets caller override .row" do
    output = @horizontal_builder.form_group class: "form-row" do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group form-row">
        <div class="col-sm-10 offset-sm-2">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "form_group overrides the label's 'class' and 'for' attributes if others are passed" do
    output = @horizontal_builder.form_group nil, label: { text: 'Custom Control', class: 'foo', for: 'bar' } do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <label class="foo col-form-label col-sm-2" for="bar">Custom Control</label>
        <div class="col-sm-10">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test 'upgrade doc for form_group renders the "error" class and message corrrectly when object is invalid' do
    @user.email = nil
    assert @user.invalid?

    output = @builder.form_group :email do
      html = %{<p class="form-control-plaintext">Bar</p>}.html_safe
      html.concat(content_tag(:div, @user.errors[:email].join(", "), class: "invalid-feedback", style: "display: block;")) unless @user.errors[:email].empty?
      html
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <p class="form-control-plaintext">Bar</p>
        <div class="invalid-feedback" style="display: block;">can't be blank, is too short (minimum is 5 characters)</div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test 'upgrade doc for form_group renders check box corrrectly when object is invalid' do
    @user.errors.add(:misc, "Must select one.")

    output = bootstrap_form_for(@user) do |f|
      f.form_group :email do
        f.radio_button(:misc, "primary school")
         .concat(f.radio_button(:misc, "high school"))
         .concat(f.radio_button(:misc, "university", error_message: true))
      end
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_primary_school" name="user[misc]" type="radio" value="primary school"/>
            <label class="form-check-label" for="user_misc_primary_school">Primary school</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_high_school" name="user[misc]" type="radio" value="high school"/>
            <label class="form-check-label" for="user_misc_high_school">High school</label>
          </div>
          <div class="form-check">
            <input class="form-check-input is-invalid" id="user_misc_university" name="user[misc]" type="radio" value="university"/>
            <label class="form-check-label" for="user_misc_university">University</label>
            <div class="invalid-feedback">Must select one.</div>
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "adds class to wrapped form_group by a field" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group none-margin">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="search" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.search_field(:misc, wrapper_class: 'none-margin')
  end

  test "adds class to wrapped form_group by a field with errors" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <div class="form-group none-margin">
        <div class="field_with_errors">
          <label class="required" for="user_email">Email</label>
        </div>
        <div class="field_with_errors">
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="email" />
        </div>
        <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.email_field(:email, wrapper_class: 'none-margin')
  end

  test "adds class to wrapped form_group by a field with errors when bootstrap_form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: 'This is required', wrapper_class: 'none-margin')
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group none-margin">
          <label class="required" for="user_email">Email</label>
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "adds offset for form_group without label" do
    output = @horizontal_builder.form_group do
      @horizontal_builder.submit
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <div class="col-sm-10 offset-sm-2">
          <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "adds offset for form_group without label but specific label_col" do
    output = @horizontal_builder.form_group label_col: 'col-sm-5', control_col: 'col-sm-8' do
      @horizontal_builder.submit
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <div class="col-sm-8 offset-sm-5">
          <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  # TODO: What is this actually testing? Improve the test name
  test "single form_group call in horizontal form should not be smash design" do
    output = @horizontal_builder.form_group do
      "Hallo"
    end

    output = output + @horizontal_builder.text_field(:email)

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <div class="col-sm-10 offset-sm-2">Hallo</div>
      </div>
      <div class="form-group row">
        <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
        <div class="col-sm-10">
          <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "adds data-attributes (or any other options) to wrapper" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group" data-foo="bar">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="search" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.search_field(:misc, wrapper: { data: { foo: 'bar' } })
  end

  test "passing options to a form control get passed through" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <input autofocus="autofocus" class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.text_field(:email, autofocus: true)
  end

  test "doesn't throw undefined method error when the content block returns nil" do
    output = @builder.form_group :nil, label: { text: 'Foo' } do
      nil
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_nil">Foo</label>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "custom form group layout option" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group form-inline">
          <label class="mr-sm-2 required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, layout: :inline }
  end

  test "non-default column span on form is reflected in form_group" do
    non_default_horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-3", control_col: "col-sm-9" })
    output = non_default_horizontal_builder.form_group do
      %{<input class="form-control-plaintext" value="Bar">}.html_safe
    end

    expected = <<-HTML.strip_heredoc
      <div class="form-group row">
        <div class="col-sm-9 offset-sm-3">
          <input class="form-control-plaintext" value="Bar">
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, output
  end

  test "non-default column span on form isn't mutated" do
    frozen_horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-3".freeze, control_col: "col-sm-9".freeze })
    output = frozen_horizontal_builder.form_group { 'test' }

    expected = %{<div class="form-group row"><div class="col-sm-9 offset-sm-3">test</div></div>}
    assert_equivalent_xml expected, output
  end

  test ":input_group_class should apply to input-group" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label class="required" for="user_email">Email</label>
        <div class="input-group input-group-lg">
          <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          <div class="input-group-append">
            <input class="btn btn-primary" name="commit" type="submit" value="Subscribe" />
          </div>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.email_field(:email, append: @builder.primary('Subscribe'), input_group_class: 'input-group-lg')
  end
end
