class UserMailer < ActionMailer::Base
  def timesheet_ready_notify(user)
    mail(
      from: ENV['EMAIL_FROM'],
      to: user.email,
      subject: 'You have finished report!',
      body: "Thank you for finishing the report!"
    )
  end

  def timesheet_not_ready_notify(user)
    mail(
      from: ENV['EMAIL_FROM'],
      to: user.email,
      subject: 'You have unfinished report!',
      body: "Please finish your report at #{ENV['REPORTS_URL']}."
    )
  end
end
