class UserService
  @@current_week = Date.today.strftime("%U").to_i

  def self.create_new_timesheets(user = nil)
    users = user ? [user] : User.all
    users.each do |user|
      report = Report.create(user_id: user.id, week_id: @@current_week)
      Category.all.each { |category| Hour.create(category_id: category.id, report_id: report.id, created_at: report.created_at) }
    end
  end

  def self.lock_timesheets
    reports = Report.where(timesheet_locked: false).where.not(week_id: @@current_week)
    reports.each do |report|
      hours_count = report.hours.map { |hour| hour.week_attrs.values.compact.sum }.sum
      report.update(timesheet_locked: true) if hours_count > 0
      UserMailer.delay.timesheet_ready_notify(report.user, report) if hours_count > 0
    end
  end

  def self.timesheet_not_ready_notify
    reports = Report.where(timesheet_locked: false).where.not(week_id: @@current_week)
    reports.each { |report| UserMailer.delay.timesheet_not_ready_notify(report.user, report) }
  end
end
