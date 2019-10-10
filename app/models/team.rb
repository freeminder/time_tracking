# frozen_string_literal: true

# Team model
class Team < ApplicationRecord
  has_many :users, dependent: :nullify

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, on: :create
end
