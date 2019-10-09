# frozen_string_literal: true

# Hour model
class Hour < ApplicationRecord
  belongs_to :report
  belongs_to :category
  delegate :user, to: :report, allow_nil: true

  validates :category, presence: true, on: %i[create update]
  validates :report, presence: true, on: :update
  validate :zero_values, on: %i[create update]

  def week_attrs
    attributes.except('id', 'created_at', 'report_id', 'category_id')
  end

  private

  def zero_values
    # do a nice output without useless values in the timesheet
    return unless week_attrs.values.compact.select(&:zero?).any?

    update(week_attrs.map do |k, v|
      v && v.zero? ? [k.to_sym, nil] : [k.to_sym, v]
    end.to_h)
  end
end
