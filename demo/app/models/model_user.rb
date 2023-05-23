class ModelUser
  include ActiveModel::Model
  attr_accessor :email, :password, :comments, :misc

  validates :email, :password, presence: true
end
