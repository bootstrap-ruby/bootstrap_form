require_relative "./test_helper"

if ::Rails::VERSION::STRING > "6"
  class BootstrapRichTextAreaTest < ActionView::TestCase
    tests ActionText::TagHelper
    include BootstrapForm::ActionViewExtensions::FormHelper

    setup :setup_test_fixture

    test "rich text areas are wrapped correctly" do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_life_story">Life story</label>
          <input type="hidden" name="user[life_story]" id="user_life_story_trix_input_user"/>
          <trix-editor id="user_life_story" data-blob-url-template="#{data_blob_url_template}" data-direct-upload-url="http://test.host/rails/active_storage/direct_uploads" input="user_life_story_trix_input_user" class="trix-content form-control" />
        </div>
      HTML
      assert_equivalent_xml expected, form_with_builder.rich_text_area(:life_story)
    end

    def data_blob_url_template
      "http://test.host/rails/active_storage/blobs/#{'redirect/' if ::Rails::VERSION::STRING >= '6.1'}:signed_id/:filename"
    end
  end
end
