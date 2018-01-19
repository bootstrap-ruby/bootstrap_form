class User < ActiveRecord::Base
  serialize :preferences

  validates :email, presence: true, :length => { minimum: 5 }
  validates :terms, acceptance: { accept: true }

  has_one :address
  accepts_nested_attributes_for :address
end
