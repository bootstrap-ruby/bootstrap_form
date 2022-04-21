# frozen_string_literal: true

module BootstrapForm
  module Components
    module Layout
      extend ActiveSupport::Concern

      private

      def layout_default?(field_layout=nil)
        layout_in_effect(field_layout) == :default
      end

      def layout_horizontal?(field_layout=nil)
        layout_in_effect(field_layout) == :horizontal
      end

      def layout_inline?(field_layout=nil)
        layout_in_effect(field_layout) == :inline
      end

      def field_inline_override?(field_layout=nil)
        field_layout == :inline && layout != :inline
      end

      # true and false should only come from check_box and radio_button,
      # and those don't have a :horizontal layout
      def layout_in_effect(field_layout)
        field_layout = :inline if field_layout == true
        field_layout = :default if field_layout == false
        field_layout || layout
      end

      def get_group_layout(group_layout)
        group_layout || layout
      end
    end
  end
end
