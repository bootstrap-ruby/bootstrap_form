class BootstrapController < ApplicationController
  def form
    load_models
  end

  def fragment
    @erb = params[:erb]

    unless @erb.start_with? "<%= bootstrap"
      @erb.prepend "<%= bootstrap_form_with model: @user, layout: :horizontal, local: true do |f| %>\n"
      @erb << "<% end %>"
    end
    @erb.prepend '<div class="p-3 border">'
    @erb << "</div>"
    load_models
    render inline: @erb, layout: "application" # rubocop: disable Rails/RenderInline
  end

  private

  def load_models
    @collection = [
      Address.new(id: 1, street: "Foo"),
      Address.new(id: 2, street: "Bar")
    ]

    @user = User.new

    @user_with_error = User.new
    @user_with_error.errors.add(:email)
    @user_with_error.errors.add(:misc)
  end
end
