ENV["RAILS_ENV"] ||= "test"

require "diffy"
require "nokogiri"
require "equivalent-xml"

require_relative "../demo/config/environment"
require "rails/test_help"
require "mocha/minitest"

Rails.backtrace_cleaner.remove_silencers!

class ActionView::TestCase
  def setup_test_fixture
    @user = User.new(email: "steve@example.com", password: "secret", comments: "my comment")
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self,
                                                         layout: :horizontal,
                                                         label_col: "col-sm-2",
                                                         control_col: "col-sm-10")

    I18n.backend.store_translations(:en,
                                    activerecord: {
                                      attributes: {
                                        user: {
                                          email: "Email"
                                        }
                                      },
                                      help: {
                                        user: {
                                          password: "A good password should be at least six characters long"
                                        }
                                      }
                                    })
  end

  # Originally only used in one test file but placed here in case it's needed in others in the future.
  def form_with_builder
    builder = nil
    bootstrap_form_with(model: @user) { |f| builder = f }
    builder
  end

  def sort_attributes(doc)
    doc.dup.traverse do |node|
      if node.is_a?(Nokogiri::XML::Element)
        attributes = node.attribute_nodes.sort_by(&:name)
        attributes.each do |attribute|
          node.delete(attribute.name)
          node[attribute.name] = attribute.value
        end
      end
      node
    end
  end

  def assert_equivalent_html(expected, actual)
    expected = expected.tr("’", "'") if Rails::VERSION::STRING < "7.1"
    expected_html        = Nokogiri::HTML.fragment(expected) { |config| config.default_xml.noblanks }
    actual_html          = Nokogiri::HTML.fragment(actual) { |config| config.default_xml.noblanks }

    expected_html = sort_attributes(expected_html)
    actual_html = sort_attributes(actual_html)

    equivalent = EquivalentXml.equivalent?(
      expected_html, actual_html, element_order: true
    ) do |a, b, result|
      looser_result = equivalent_with_looser_criteria?(a, b, result)
      break false unless looser_result
      looser_result
    end

    assert equivalent, lambda {
      # using a lambda because diffing is expensive
      Diffy::Diff.new(
        expected_html.to_html(indent: 2),
        actual_html.to_html(indent: 2)
      ).to_s(:color)
    }
  end

  private

  def equivalent_with_looser_criteria?(expected, real, result)
    return result if result

    if real.attr(:name) == "utf8"
      # Handle wrapped utf8 hidden field for Rails 4.2+
      expected = expected.child
    end

    real.delete("data-disable-with")

    if expected.is_a?(Nokogiri::XML::Attr) &&
      real.is_a?(Nokogiri::XML::Attr) &&
      expected.value == "datetime" &&
      real.value == "datetime-local"
      return true
    end

    EquivalentXml.equivalent?(expected, real, element_order: true)
  end

  def autocomplete_attr
    'autocomplete="off"' if ::Rails::VERSION::STRING >= "6.1"
  end
end
