# frozen_string_literal: true

# add new category to existing reports
class AddCategoryToReportsWorker
  include Sidekiq::Worker

  def perform(category_id)
    Report.all.each do |report|
      report.hours.create(category_id: category_id,
                          created_at: report.created_at)
    end
  end
end
