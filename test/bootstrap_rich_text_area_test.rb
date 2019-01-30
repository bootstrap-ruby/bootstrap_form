require_relative "./test_helper"
require "byebug"

class BootstrapRichTextAreaTest < ActionView::TestCase
  tests ActionText::TagHelper
  include BootstrapForm::Helper

  setup :setup_test_fixture

  if ::Rails::VERSION::STRING > "6"
    test "rich text areas are wrapped correctly" do
      puts "respond_to?(:rich_text_area): #{respond_to?(:rich_text_area)}"
      puts "respond_to?(:rich_text_area_without_bootstrap): #{respond_to?(:rich_text_area_without_bootstrap)}"
      puts "respond_to?(:rich_text_area_tag): #{respond_to?(:rich_text_area_tag)}"
      puts "respond_to?(:main_app): #{respond_to?(:main_app)}"
      # puts method(:main_app).source_location

      expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_life_story">Life story</label>
        <input type="hidden" name="user[life_story]" id="user_life_story_trix_input_user"/>
        <trix-editor id="user_life_story" data-blob-url-template="http://test.host/rails/active_storage/blobs/:signed_id/:filename" data-direct-upload-url="http://test.host/rails/active_storage/direct_uploads" input="user_life_story_trix_input_user" class="trix-content form-control"/>
        </trix-editor>
      </div>
      HTML
      assert_equivalent_xml expected, form_with_builder.rich_text_area(:life_story)
    end
  end
end
