# frozen_string_literal: true

# create new timesheets for new user or existing ones
class CreateNewTimesheetsWorker
  include Sidekiq::Worker

  def perform(user_id = nil)
    current_week = Date.today.strftime('%U').to_i
    users = user_id ? [User.find(user_id)] : User.all

    users.each do |user|
      report = Report.create(user_id: user.id, week_id: current_week)
      Category.all.each do |category|
        Hour.create(category_id: category.id, report_id: report.id,
                    created_at: report.created_at)
      end
    end
  end
end
