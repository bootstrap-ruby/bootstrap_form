require 'timecop'
require 'diffy'
require 'nokogiri'
require 'equivalent-xml'
require 'mocha/mini_test'

ENV["RAILS_ENV"] = "test"

require_relative "./dummy/config/environment.rb"
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

class ActionView::TestCase

  def setup_test_fixture
    @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    # Simulate how the builder would be called from `form_with`.
    if '5.1' <= ::Rails::VERSION::STRING && ::Rails::VERSION::STRING < '5.2'
      @form_with_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { skip_default_ids: true })
    else
      @form_with_builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
    end
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

  def assert_equivalent_xml(expected, actual)
    # expected_xml = expected.is_a?(String) ? Nokogiri::XML(expected) : expected
    expected_xml        = Nokogiri::XML(expected)
    actual_xml          = Nokogiri::XML(actual)
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
        sort_attributes(expected_xml.root),
        sort_attributes(actual_xml.root)
      ).to_s(:color)
    }
  end

  ##
  # Test with the @builder, and with @form_with_builder if Rails 5.1+
  def assert_with_builder(expected, method, *args)
    assert_equivalent_xml expected, @builder.send(method, *args)
    if ::Rails::VERSION::STRING >= '5.1'
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
                            @form_with_builder.send(method, *args)
    end
  end

  def assert_with_builder_radio(expected, *args)
    assert_equivalent_xml expected, @builder.radio_button(*args)
    if ::Rails::VERSION::STRING >= '5.1'
      assert_equivalent_xml remove_default_ids_for_rails_5_1(expected),
                            @form_with_builder.radio_button(*args)
    end
  end

  ##
  # Remove ids on labels if running on Rails 5.1
  def remove_default_ids_for_rails_5_1(expected)
    return expected unless '5.1' <= ::Rails::VERSION::STRING && ::Rails::VERSION::STRING < '5.2'
    root = Nokogiri::XML(expected)
    # puts("NODE: #{root}")
    # puts("NODE CHILDREN: #{root.children}")
    # nodes.remove_attr("id")
    # There are more elegant ways to do this, I'm sure, but later for that.
    root.traverse do |node|
      # puts("NODE: #{node}: #{node.name}")
      node.delete("id") if node.has_attribute?("id")
      # node.delete("for") if node.name.downcase == "label" && node.has_attribute?("for")
    end
    root.to_s
  end
end
