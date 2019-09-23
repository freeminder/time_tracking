class Hour < ActiveRecord::Base
  belongs_to :report
  belongs_to :category
  delegate :user, to: :report, allow_nil: true

  validates :category, presence: :true, on: [:create, :update]
  validates :report, presence: :true, on: [:update]
  validate :zero_values, on: [:update, :create]

  def week_attrs
    attributes.except("id", "created_at", "report_id", "category_id")
  end


  private

  def zero_values
    # do a nice output without useless values in the timesheet
    update_attributes(week_attrs.map { |k,v| v == 0 ? [k.to_sym,nil] : [k.to_sym,v] }.to_h) if week_attrs.select { |k,v| v == 0 }.any?
  end
end
