class User < ApplicationRecord
  attr_accessor :remember_me

  if Rails::VERSION::STRING >= "6.1"
    serialize :preferences, coder: JSON
  else
    serialize :preferences, JSON
  end

  validates :email, presence: true, length: { minimum: 5 }
  validates :terms, acceptance: { accept: true }

  # Conditional (always disabled) validators used in tests
  validates :status, presence: true, if: -> { age > 42 }
  validates :misc, presence: true, unless: -> { feet == 5 }

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
