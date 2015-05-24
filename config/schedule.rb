# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever


# set :environment, :development

every :monday, :at => '3:59 pm' do # Use any day of the week or :weekend, :weekday
  runner "User.lock_timesheets"
  # rake "jobs:work"
end

every :weekday, :at => '4:00 pm' do # Use any day of the week or :weekend, :weekday
  runner "User.timesheet_not_ready_notify"
  # rake "jobs:work"
end

# every 2.minutes do
#   runner "User.timesheet_not_ready_notify"
#   # rake "jobs:work"
# end

