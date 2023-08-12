require_relative "test_helper"

class SpecialFormClassModelsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  test "Anonymous models are supported for form builder" do
    user_klass = Class.new(User)

    def user_klass.model_name
      ActiveModel::Name.new(User)
    end

    @user = user_klass.new(email: "steve@example.com", password: "secret", comments: "my comment")
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder =
      BootstrapForm::FormBuilder.new(:user, @user, self, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10")
    I18n.backend.store_translations(:en, activerecord: { help: { user: {
                                      password: "A good password should be at least six characters long"
                                    } } })
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.date_field(:misc)
  end

  test "Nil models are supported for form builder" do
    @user = nil
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder =
      BootstrapForm::FormBuilder.new(:user, @user, self, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10")
    I18n.backend.store_translations(:en, activerecord: { help: { user: {
                                      password: "A good password should be at least six characters long"
                                    } } })
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.date_field(:misc)
  end

  test "Objects without model names are supported for form builder" do
    @user = FauxUser.new(email: "steve@example.com", password: "secret", comments: "my comment")
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder =
      BootstrapForm::FormBuilder.new(:user, @user, self, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10")
    I18n.backend.store_translations(:en, activerecord: { help: { faux_user: {
                                      password: "A good password should be at least six characters long"
                                    } } })

    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_html expected, @builder.date_field(:misc)
  end

  test "ActiveModel objects are supported for form builder" do
    @user = ModelUser.new(email: "steve@example.com", comments: "my comment")
    assert_equal false, @user.valid?
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, layout: :horizontal, label_col: "col-sm-2",
                                                                             control_col: "col-sm-10")
    I18n.backend.store_translations(:en, activerecord: { help: { faux_user: {
                                      password: "A good password should be at least six characters long"
                                    } } })

    expected = <<~HTML
      <div class="mb-3">
        <div class="field_with_errors">
          <label class="form-label required" for="user_password">Password</label>
        </div>
        <div class="field_with_errors">
          <input aria-required="true" class="form-control is-invalid" id="user_password" name="user[password]" required="required" type="text">
        </div>
        <div class="invalid-feedback">can#{Rails::VERSION::MAJOR < 7 ? "'" : '’'}t be blank</div>
      </div>
    HTML
    assert_equivalent_html expected, @builder.text_field(:password)
  end
end
