# frozen_string_literal: true

# Category model
class Category < ApplicationRecord
  has_many :hours
  has_many :reports, through: :hours

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, on: :create

  before_destroy :remove_hours_later, prepend: true

  def remove_hours_later
    RemoveHoursFromCategoryWorker.perform_async(id)
  end
end
