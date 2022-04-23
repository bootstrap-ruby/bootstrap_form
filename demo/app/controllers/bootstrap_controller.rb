class BootstrapController < ApplicationController
  def form
    @collection = [
      Address.new(id: 1, street: "Foo"),
      Address.new(id: 2, street: "Bar")
    ]

    @user = User.new

    @user_with_error = User.new
    @user_with_error.errors.add(:email)
    @user_with_error.errors.add(:misc)

    if (@erb = params[:erb])
      unless @erb.start_with? "<%= bootstrap"
        @erb.prepend "<%= bootstrap_form_with model: @user, layout: :horizontal, local: true do |f| %>\n"
        @erb << "<% end %>"
      end
      @erb.prepend %{<div class="p-3">}
      @erb << "</div>"
      render inline: @erb, layout: "application"
    end
  end
end
