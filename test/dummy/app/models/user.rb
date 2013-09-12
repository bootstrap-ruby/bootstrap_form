class User < ActiveRecord::Base
  serialize :preferences, Hash.new(favorite_color: "circulian", favorite_animal: "platypus")

  validates :email, presence: true, :length => { minimum: 5 }

  has_one :address
  accepts_nested_attributes_for :address
end
