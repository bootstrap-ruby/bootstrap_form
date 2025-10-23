require_relative "test_helper"
require "minitest/mock"

class BootstrapRichTextAreaTest < ActionView::TestCase
  tests ActionText::TagHelper
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  test "rich text areas are wrapped correctly" do
    expected = nil
    with_stub_token do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_life_story">Life story</label>
          <input type="hidden" #{autocomplete_attr} name="user[life_story]" id="user_life_story_trix_input_user"/>
          <trix-editor class="trix-content form-control" extra="extra arg" data-blob-url-template="http://test.host/rails/active_storage/blobs/redirect/:signed_id/:filename" data-direct-upload-url="http://test.host/rails/active_storage/direct_uploads" id="user_life_story" input="user_life_story_trix_input_user"/>
        </div>
      HTML
    end
    assert_equivalent_html expected, form_with_builder.rich_text_area(:life_story, extra: "extra arg")
  end

  if Rails::VERSION::MAJOR >= 8
    test "rich text areas are aliased" do
      expected = nil
      with_stub_token do
        expected = <<~HTML
          <div class="mb-3">
            <label class="form-label" for="user_life_story">Life story</label>
            <input autocomplete="off" type="hidden" name="user[life_story]" id="user_life_story_trix_input_user"/>
            <trix-editor class="trix-content form-control" extra="extra arg" data-blob-url-template="http://test.host/rails/active_storage/blobs/redirect/:signed_id/:filename" data-direct-upload-url="http://test.host/rails/active_storage/direct_uploads" id="user_life_story" input="user_life_story_trix_input_user"/>
          </div>
        HTML
      end
      assert_equivalent_html expected, form_with_builder.rich_textarea(:life_story, extra: "extra arg")
    end
  end

  def data_blob_url_template
    "http://test.host/rails/active_storage/blobs/redirect/:signed_id/:filename"
  end

  def with_stub_token(&)
    unless defined?(ActiveStorage::DirectUploadToken)
      yield
      return
    end

    ActiveStorage::DirectUploadToken.stub(:generate_direct_upload_token, "token", &)
  end
end
