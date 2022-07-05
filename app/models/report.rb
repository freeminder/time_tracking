# frozen_string_literal: true

# Report model
class Report < ApplicationRecord
  belongs_to :user
  has_many :hours, dependent: :delete_all
  accepts_nested_attributes_for :hours
  has_many :categories, through: :hours

  # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :user, presence: true, on: %i[create update]
  # rubocop:enable Rails/RedundantPresenceValidationOnBelongsTo
end
