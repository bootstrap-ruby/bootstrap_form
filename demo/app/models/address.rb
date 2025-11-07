# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :city, presence: true
end
