# frozen_string_literal: true

# Category model
class Category < ApplicationRecord
  has_many :hours, dependent: :delete_all
  has_many :reports, through: :hours

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, on: :create
end
