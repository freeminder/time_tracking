# frozen_string_literal: true

# notify users about their timesheets whose are not ready
class TimesheetNotReadyNotificationWorker
  include Sidekiq::Worker

  def perform
    current_week = Time.zone.today.strftime('%U').to_i
    reports = Report.where(timesheet_locked: false)
                    .where.not(week_id: current_week)

    reports.each do |report|
      UserMailer.timesheet_not_ready_notify(report.user, report).deliver_now
    end
  end
end
