# NOTE: The rich_text_area and rich_text_area_tag helpers are defined in a file with a different
# name and not in the usual autoload-reachable way.
require "#{Gem::Specification.find_by_name("actiontext").gem_dir}/app/helpers/action_text/tag_helper"
require "bootstrap_form/form_builder"
require "bootstrap_form/helper"

module BootstrapForm
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end

ActiveSupport.on_load(:action_view) do
  puts "Loading ActionView, about to include BootstrapForm::Helper"
  include BootstrapForm::Helper
end
