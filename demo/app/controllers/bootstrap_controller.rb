class BootstrapController < ApplicationController

  def form
    @collection = [
      Address.new(id: 1, street: 'Foo'),
      Address.new(id: 2, street: 'Bar')
    ]

    @user = User.new

    @user_with_error = User.new
    @user_with_error.errors.add(:email)
    @user_with_error.errors.add(:misc)
  end

end
