class Hour < ActiveRecord::Base
  belongs_to :report
  belongs_to :category
  delegate :user, :to => :report, :allow_nil => true
  validate :zero_values, on: [:update, :create]

  def zero_values
    # do a nice output without useless values in the timesheet
    attrs = attributes.except("id", "report_id", "category_id", "created_at")
    update_attributes(attrs.map { |k,v| v == 0 ? [k.to_sym,nil] : [k.to_sym,v] }.to_h) if attrs.select { |k,v| v == 0 }.any?
  end
end
