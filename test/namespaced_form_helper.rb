# frozen_string_literal: true

module NamespacedFormHelper
  def namespaced_form_for(**args)
    bootstrap_form_for(@user, namespace: "name_space", **args) { |f| @namespaced_form_for = f }
    @namespaced_form_for
  end

  def namespaced_form_with(**args)
    bootstrap_form_with(model: @user, namespace: "name_space", **args) { |f| @namespaced_form_with = f }
    @namespaced_form_with
  end
end
