class User < ActiveRecord::Base
  validates :email, presence: true, :length => { minimum: 5 }
end
