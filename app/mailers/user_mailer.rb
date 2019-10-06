# frozen_string_literal: true

# User mailer
class UserMailer < ActionMailer::Base
  def timesheet_ready_notify(user, report)
    @user = user
    @report = report

    mail(
      from: ENV['EMAIL_FROM'],
      to: user.email,
      subject: 'You have a finished report!'
    )
  end

  def timesheet_not_ready_notify(user, report)
    @user = user
    @report = report

    mail(
      from: ENV['EMAIL_FROM'],
      to: user.email,
      subject: 'You have an unfinished report!'
    )
  end
end
