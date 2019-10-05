# frozen_string_literal: true

# lock completed timesheets for all users in the beginning of the week
class LockTimesheetsWorker
  include Sidekiq::Worker

  def perform
    current_week = Date.today.strftime('%U').to_i
    reports = Report.where(timesheet_locked: false)
                    .where.not(week_id: current_week)

    reports.each { |report| lock_timesheet(report) }
  end

  private

  def lock_timesheet(report)
    hours = report.hours.map { |hour| hour.week_attrs.values.compact.sum }.sum
    return unless hours.positive?

    report.update(timesheet_locked: true)
    UserMailer.timesheet_ready_notify(report.user, report).deliver_now
  end
end
