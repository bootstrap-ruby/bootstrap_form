require 'timecop'
require 'diffy'
require 'nokogiri'
require 'equivalent-xml'
require 'mocha/mini_test'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def setup_test_fixture
  @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
  @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10" })
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

class ActionView::TestCase
  def assert_equivalent_xml(expected, actual)
    expected_xml = Nokogiri::XML(expected)
    actual_xml = Nokogiri::XML(actual)
    ignored_attributes = %w(style data-disable-with)
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
end
