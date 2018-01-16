require_relative "./test_helper"

class SpecialFormClassModelsTest < ActionView::TestCase
  include BootstrapForm::Helper

  test "Anonymous models are supported for form builder" do
    user_klass = Class.new(User)
    def user_klass.model_name
      ActiveModel::Name.new(User)
    end

    @user = user_klass.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, {layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10"})
    I18n.backend.store_translations(:en, {activerecord: {help: {user: {password: "A good password should be at least six characters long"}}}})

    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.date_field(:misc)
  end

  test "Nil models are supported for form builder" do
    @user = nil
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, {layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10"})
    I18n.backend.store_translations(:en, {activerecord: {help: {user: {password: "A good password should be at least six characters long"}}}})

    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.date_field(:misc)
  end

  test "Objects without model names are supported for form builder" do
    user_klass = FauxUser

    @user = user_klass.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, {layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10"})
    I18n.backend.store_translations(:en, {activerecord: {help: {faux_user: {password: "A good password should be at least six characters long"}}}})

    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <input class="form-control" id="user_misc" name="user[misc]" type="date" />
      </div>
    HTML
    assert_equivalent_xml expected, @builder.date_field(:misc)
  end

end
