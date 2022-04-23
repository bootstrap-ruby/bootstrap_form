class User < ApplicationRecord
  attr_accessor :remember_me

  serialize :preferences

  validates :email, presence: true, length: { minimum: 5 }
  validates :terms, acceptance: { accept: true }

  has_one :address
  accepts_nested_attributes_for :address

  has_rich_text(:life_story) if Rails::VERSION::STRING > "6"

  def age
    42
  end

  def feet
    5
  end

  def inches
    7
  end
end
