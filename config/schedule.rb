# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever


# set :environment, :development


every :sunday, :at => '0:01 am' do # Use any day of the week or :weekend, :weekday
  runner "User.create_new_timesheets"
end

every :monday, :at => '4:00 pm' do # Use any day of the week or :weekend, :weekday
  runner "User.lock_timesheets"
end

every :weekday, :at => '0:00 am' do # Use any day of the week or :weekend, :weekday
  runner "User.lock_timesheets"
end


every :weekday, :at => '4:01 pm' do # Use any day of the week or :weekend, :weekday
  runner "User.timesheet_not_ready_notify"
end

# every 2.minutes do
#   runner "User.timesheet_not_ready_notify"
#   # rake "jobs:work"
# end

