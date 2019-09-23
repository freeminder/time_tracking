# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# set :environment, :development

# Use any day of the week or :weekend, :weekday
every :sunday, :at => "0:00 am" do
  runner "UserService.lock_timesheets"
end

every :sunday, :at => "0:00 am" do
  runner "UserService.create_new_timesheets"
end

every :weekday, :at => "4:00 pm" do
  runner "UserService.timesheet_not_ready_notify"
end
