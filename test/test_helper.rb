ENV['RAILS_ENV'] ||= 'test'

require 'timecop'
require 'diffy'
require 'nokogiri'
require 'equivalent-xml'

require_relative "../demo/config/environment.rb"
require "rails/test_help"
require 'mocha/minitest'

Rails.backtrace_cleaner.remove_silencers!

class ActionView::TestCase

  def setup_test_fixture
    @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, {
      layout:       :horizontal,
      label_col:    "col-sm-2",
      control_col:  "col-sm-10"
    })

    I18n.backend.store_translations(:en, {
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
      }
    })
  end

  # Originally only used in one test file but placed here in case it's needed in others in the future.
  def form_with_builder
    builder = nil
    bootstrap_form_with(model: @user) { |f| builder = f }
    builder
  end

  def sort_attributes doc
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

  # Expected and actual are wrapped in a root tag to ensure proper XML structure
  def assert_equivalent_xml(expected, actual)
    expected_xml        = Nokogiri::XML("<test-xml>\n#{expected}\n</test-xml>") { |config| config.default_xml.noblanks }
    actual_xml          = Nokogiri::XML("<test-xml>\n#{actual}\n</test-xml>") { |config| config.default_xml.noblanks }
    ignored_attributes  = %w(style data-disable-with)

    equivalent = EquivalentXml.equivalent?(expected_xml, actual_xml, {
      ignore_attr_values: ignored_attributes
    }) do |a, b, result|
      if result === false && b.is_a?(Nokogiri::XML::Element)
        if b.attr('name') == 'utf8'
          # Handle wrapped utf8 hidden field for Rails 4.2+
          result = EquivalentXml.equivalent?(a.child, b)
        end
        if b.delete('data-disable-with')
          # Remove data-disable-with for Rails 5+
          # Workaround because ignoring in EquivalentXml doesn't work
          result = EquivalentXml.equivalent?(a, b)
        end
        if a.attr('type') == 'datetime' && b.attr('type') == 'datetime-local'
          a.delete('type')
          b.delete('type')
          # Handle new datetime type for Rails 5+
          result = EquivalentXml.equivalent?(a, b)
        end
      end
      result
    end

    assert equivalent, lambda {
      # using a lambda because diffing is expensive
      Diffy::Diff.new(
        sort_attributes(expected_xml.root).to_xml(indent: 2),
        sort_attributes(actual_xml.root).to_xml(indent: 2)
      ).to_s(:color)
    }
  end
end
