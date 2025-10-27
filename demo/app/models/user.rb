class User < ApplicationRecord
  attr_accessor :remember_me

  serialize :preferences, coder: JSON

  validates :email, presence: true, length: { minimum: 5 }, if: :always?
  validates :terms, acceptance: { accept: true }

  # Conditional (always disabled) validators used in tests
  validates :status, presence: true, if: -> { age > 42 }
  validates :misc, presence: true, unless: -> { feet == 5 }

  has_one :address, dependent: nil
  accepts_nested_attributes_for :address

  has_rich_text(:life_story)

  def always?
    true
  end

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
