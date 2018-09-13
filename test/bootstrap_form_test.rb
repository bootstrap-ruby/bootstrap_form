require_relative "./test_helper"

class BootstrapFormTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  test "default-style forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| nil }
  end

  test "default-style form fields layout horizontal" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
        <div class="form-check">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="form-group row">
          <label class="col-form-label col-sm-2" for="user_misc">Misc</label>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
              <label class="form-check-label" for="user_misc_1"> Foo</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
              <label class="form-check-label" for="user_misc_2"> Bar</label>
            </div>
          </div>
        </div>
        <div class="form-group row">
          <label class="col-form-label col-sm-2" for="user_status">Status</label>
          <div class="col-sm-10">
            <select class="form-control" id="user_status" name="user[status]">
              <option value="1">activated</option>
              <option value="2">blocked</option>
            </select>
          </div>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    actual = bootstrap_form_for(@user) do |f|
      f.email_field(:email, layout: :horizontal)
       .concat(f.check_box(:terms, label: 'I agree to the terms'))
       .concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :horizontal))
       .concat(f.select(:status, [['activated', 1], ['blocked', 2]], layout: :horizontal))
    end

    assert_equivalent_xml expected, actual
    # See the rendered output at: https://www.bootply.com/S2WFzEYChf
  end

  test "default-style form fields layout inline" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group form-inline">
          <label class="mr-sm-2 required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="form-check form-check-inline">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="form-group form-inline">
          <label class="mr-sm-2" for="user_misc">Misc</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
          </div>
        </div>
        <div class="form-group form-inline">
          <label class="mr-sm-2" for="user_status">Status</label>
          <select class="form-control" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    actual = bootstrap_form_for(@user) do |f|
      f.email_field(:email, layout: :inline)
       .concat(f.check_box(:terms, label: 'I agree to the terms', inline: true))
       .concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :inline))
       .concat(f.select(:status, [['activated', 1], ['blocked', 2]], layout: :inline))
    end

    assert_equivalent_xml expected, actual
    # See the rendered output at: https://www.bootply.com/fH5sF4fcju
    # Note that the baseline of the label text to the left of the two radio buttons
    # isn't aligned with the text of the radio button labels.
    # TODO: Align baseline better.
  end

  if  ::Rails::VERSION::STRING >= '5.1'
    # No need to test 5.2 separately for this case, since 5.2 does *not*
    # generate a default ID for the form element.
    test "default-style forms bootstrap_form_with Rails 5.1+" do
      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" data-remote="true" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
        </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_with(model: @user) { |f| nil }
    end
  end

  test "inline-style forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="form-inline" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="mr-sm-2 required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="form-check form-check-inline">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="form-group">
          <label class="mr-sm-2" for="user_misc">Misc</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
          </div>
        </div>
        <div class="form-group">
          <label class="mr-sm-2" for="user_status">Status</label>
          <select class="form-control" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    actual = bootstrap_form_for(@user, layout: :inline) do |f|
      f.email_field(:email)
       .concat(f.check_box(:terms, label: 'I agree to the terms'))
       .concat(f.collection_radio_buttons(:misc, collection, :id, :street))
       .concat(f.select(:status, [['activated', 1], ['blocked', 2]]))
    end

    assert_equivalent_xml expected, actual
  end

  test "horizontal-style forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
        <div class="form-check">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="form-group row">
          <label class="col-form-label col-sm-2" for="user_misc">Misc</label>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
              <label class="form-check-label" for="user_misc_1"> Foo</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
              <label class="form-check-label" for="user_misc_2"> Bar</label>
            </div>
          </div>
        </div>
        <div class="form-group row">
          <label class="col-form-label col-sm-2" for="user_status">Status</label>
          <div class="col-sm-10">
            <select class="form-control" id="user_status" name="user[status]">
              <option value="1">activated</option>
              <option value="2">blocked</option>
            </select>
          </div>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      f.email_field(:email)
       .concat(f.check_box(:terms, label: 'I agree to the terms'))
       .concat(f.collection_radio_buttons(:misc, collection, :id, :street))
       .concat(f.select(:status, [['activated', 1], ['blocked', 2]]))
    end

    assert_equivalent_xml expected, actual
  end

  test "horizontal-style form fields layout default" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="form-check">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
          </div>
        </div>
        <div class="form-group">
          <label for="user_status">Status</label>
          <select class="form-control" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      f.email_field(:email, layout: :default)
       .concat(f.check_box(:terms, label: 'I agree to the terms'))
       .concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :default))
       .concat(f.select(:status, [['activated', 1], ['blocked', 2]], layout: :default))
    end

    assert_equivalent_xml expected, actual
    # See the rendered output at: https://www.bootply.com/4f23be1nLn
  end

  test "horizontal-style form fields layout inline" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group form-inline">
          <label class="mr-sm-2 required" for="user_email">Email</label>
          <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
        </div>
        <div class="form-check form-check-inline">
          <input name="user[terms]" type="hidden" value="0" />
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1" />
          <label class="form-check-label" for="user_terms">I agree to the terms</label>
        </div>
        <div class="form-group form-inline">
          <label class="mr-sm-2" for="user_misc">Misc</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_1" name="user[misc]" type="radio" value="1" />
            <label class="form-check-label" for="user_misc_1"> Foo</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" id="user_misc_2" name="user[misc]" type="radio" value="2" />
            <label class="form-check-label" for="user_misc_2"> Bar</label>
          </div>
        </div>
        <div class="form-group form-inline">
          <label class="mr-sm-2" for="user_status">Status</label>
          <select class="form-control" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
        </div>
      </form>
    HTML

    collection = [Address.new(id: 1, street: 'Foo'), Address.new(id: 2, street: 'Bar')]
    actual = bootstrap_form_for(@user, layout: :horizontal) do |f|
      f.email_field(:email, layout: :inline)
       .concat(f.check_box(:terms, label: 'I agree to the terms', inline: true))
       .concat(f.collection_radio_buttons(:misc, collection, :id, :street, layout: :inline))
       .concat(f.select(:status, [['activated', 1], ['blocked', 2]], layout: :inline))
    end

    assert_equivalent_xml expected, actual
    # See the rendered output here: https://www.bootply.com/Qby9FC9d3u#
  end

  test "existing styles aren't clobbered when specifying a form style" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="my-style" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal, html: { class: "my-style" }) { |f| f.email_field :email }
  end

  test "given role attribute should not be covered by default role attribute" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="not-a-form">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, html: { role: 'not-a-form'}) {|f| nil}
  end

  test "bootstrap_form_tag acts like a form tag" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="email">Your Email</label>
          <input class="form-control" id="email" name="email" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_tag(url: '/users') { |f| f.text_field :email, label: "Your Email" }
  end

  test "bootstrap_form_for does not clobber custom options" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="ID">Email</label>
          <input class="form-control" id="ID" name="NAME" type="text" value="steve@example.com" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.text_field :email, name: 'NAME', id: "ID" }
  end

  test "bootstrap_form_tag does not clobber custom options" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label for="ID">Email</label>
          <input class="form-control" id="ID" name="NAME" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_tag(url: '/users') { |f| f.text_field :email, name: 'NAME', id: "ID" }
  end

  test "bootstrap_form_tag allows an empty name for checkboxes" do
    if ::Rails::VERSION::STRING >= '5.1'
      id = 'misc'
      name = 'misc'
    else
      id = '_misc'
      name = '[misc]'
    end
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;" />
      <div class="form-check">
        <input class="form-check-input" id="#{id}" name="#{name}" type="checkbox" value="1" />
        <input name="#{name}" type="hidden" value="0" />
        <label class="form-check-label" for="#{id}"> Misc</label>
      </div>
    </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_tag(url: '/users') { |f| f.check_box :misc }
  end

  test "errors display correctly and inline_errors are turned off by default when label_errors is true" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required text-danger" for="user_email">Email can't be blank, is too short (minimum is 5 characters)</label>
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, label_errors: true) { |f| f.text_field :email }
  end

  test "errors display correctly and inline_errors can also be on when label_errors is true" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required text-danger" for="user_email">Email can&#39;t be blank, is too short (minimum is 5 characters)</label>
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</span>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }
  end

  test "label error messages use humanized attribute names" do
    begin
      I18n.backend.store_translations(:en, {activerecord: {attributes: {user: {email: 'Your e-mail address'}}}})

      @user.email = nil
      assert @user.invalid?

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required text-danger" for="user_email">Your e-mail address can&#39;t be blank, is too short (minimum is 5 characters)</label>
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
            <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
          </div>
        </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_for(@user, label_errors: true, inline_errors: true) { |f| f.text_field :email }

    ensure
      I18n.backend.store_translations(:en, {activerecord: {attributes: {user: {email: nil}}}})
    end
  end

  test "alert message is wrapped correctly" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <div class="alert alert-danger">
        <p>Please fix the following errors:</p>
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can&#39;t be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.alert_message('Please fix the following errors:')
  end

  test "changing the class name for the alert message" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <div class="my-css-class">
        <p>Please fix the following errors:</p>
        <ul class="rails-bootstrap-forms-error-summary">
          <li>Email can&#39;t be blank</li>
          <li>Email is too short (minimum is 5 characters)</li>
          <li>Terms must be accepted</li>
        </ul>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.alert_message('Please fix the following errors:', class: 'my-css-class')
  end

  test "alert_message contains the error summary when inline_errors are turned off" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message('Please fix the following errors:')
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can&#39;t be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "alert_message allows the error_summary to be turned off" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.alert_message('Please fix the following errors:', error_summary: false)
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "alert_message allows the error_summary to be turned on with inline_errors also turned on" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: true) do |f|
      f.alert_message('Please fix the following errors:', error_summary: true)
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="alert alert-danger">
          <p>Please fix the following errors:</p>
          <ul class="rails-bootstrap-forms-error-summary">
            <li>Email can&#39;t be blank</li>
            <li>Email is too short (minimum is 5 characters)</li>
            <li>Terms must be accepted</li>
          </ul>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "error_summary returns an unordered list of errors" do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <ul class="rails-bootstrap-forms-error-summary">
        <li>Email can&#39;t be blank</li>
        <li>Email is too short (minimum is 5 characters)</li>
        <li>Terms must be accepted</li>
      </ul>
    HTML
    assert_equivalent_xml expected, @builder.error_summary
  end

  test "error_summary returns nothing if no errors" do
    @user.terms = true
    assert @user.valid?

    assert_equal nil, @builder.error_summary
  end

  test 'errors_on renders the errors for a specific attribute when invalid' do
    @user.email = nil
    assert @user.invalid?

    expected = <<-HTML.strip_heredoc
      <div class="alert alert-danger">Email can&#39;t be blank, Email is too short (minimum is 5 characters)</div>
    HTML
    assert_equivalent_xml expected, @builder.errors_on(:email)
  end

  test "custom label width for horizontal forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-form-label col-sm-1 required" for="user_email">Email</label>
          <div class="col-sm-10">
            <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, label_col: 'col-sm-1' }
  end

  test "offset for form group without label respects label width for horizontal forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <div class="col-md-10 offset-md-2">
            <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal, label_col: 'col-md-2', control_col: 'col-md-10') { |f| f.form_group { f.submit } }
  end

  test "offset for form group without label respects multiple label widths for horizontal forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <div class="col-sm-8 col-md-10 offset-sm-4 offset-md-2">
            <input class="btn btn-secondary" name="commit" type="submit" value="Create User" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal, label_col: 'col-sm-4 col-md-2', control_col: 'col-sm-8 col-md-10') { |f| f.form_group { f.submit } }
  end

  test "custom input width for horizontal forms" do
    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group row">
          <label class="col-form-label col-sm-2 required" for="user_email">Email</label>
          <div class="col-sm-5">
            <input class="form-control" id="user_email" name="user[email]" type="email" value="steve@example.com" />
          </div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.email_field :email, control_col: 'col-sm-5' }
  end

  test "the field contains the error and is not wrapped in div.field_with_errors when bootstrap_form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</div>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "the field is wrapped with div.field_with_errors when form_for is used" do
    @user.email = nil
    assert @user.invalid?

    output = form_for(@user, builder: BootstrapForm::FormBuilder) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <div class="field_with_errors">
            <label class="required" for="user_email">Email</label>
          </div>
          <div class="field_with_errors">
            <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          </div>
          <div class="invalid-feedback">can't be blank, is too short (minimum is 5 characters)</span>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "help is preserved when inline_errors: false is passed to bootstrap_form_for" do
    @user.email = nil
    assert @user.invalid?

    output = bootstrap_form_for(@user, inline_errors: false) do |f|
      f.text_field(:email, help: 'This is required')
    end

    expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;" />
        <div class="form-group">
          <label class="required" for="user_email">Email</label>
          <input class="form-control is-invalid" id="user_email" name="user[email]" type="text" />
          <small class="form-text text-muted">This is required</small>
        </div>
      </form>
    HTML
    assert_equivalent_xml expected, output
  end

  test "help translations do not escape HTML when _html is appended to the name" do
    begin
      I18n.backend.store_translations(:en, {activerecord: {help: {user: {email_html: "This is <strong>useful</strong> help"}}}})

      output = bootstrap_form_for(@user) do |f|
        f.text_field(:email)
      end

      expected = <<-HTML.strip_heredoc
        <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <div class="form-group">
            <label class="required" for="user_email">Email</label>
            <input class="form-control" id="user_email" name="user[email]" type="text" value="steve@example.com" />
            <small class="form-text text-muted">This is <strong>useful</strong> help</small>
          </div>
        </form>
      HTML
      assert_equivalent_xml expected, output
    ensure
      I18n.backend.store_translations(:en, {activerecord: {help: {user: {email_html: nil}}}})
    end
  end

  test "allows the form object to be nil" do
    builder = BootstrapForm::FormBuilder.new :other_model, nil, self, {}
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="other_model_email">Email</label>
        <input class="form-control" id="other_model_email" name="other_model[email]" type="text" />
      </div>
    HTML
    assert_equivalent_xml expected, builder.text_field(:email)
  end

  test 'errors_on hide attribute name in message' do
    @user.email = nil
    assert @user.invalid?

    expected = %{<div class="alert alert-danger">can&#39;t be blank, is too short (minimum is 5 characters)</div>}

    assert_equivalent_xml expected, @builder.errors_on(:email, hide_attribute_name: true)
  end
end
