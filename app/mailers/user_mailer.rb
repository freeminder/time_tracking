class UserMailer < ActionMailer::Base
  # include Resque::Mailer
  # default from: "root@localhost"

  def timesheet_ready_notify(user)
    mail(
      from: "root@localhost",
      to: user.email,
      subject: 'You have finished report!',
      body: "Thank you for finishing the report!"
    )
  end

  def timesheet_not_ready_notify(user)
    mail(
      from: "root@localhost",
      to: user.email,
      subject: 'You have unfinished report!',
      body: "Please finish your report at http://ec2-52-1-198-244.compute-1.amazonaws.com/reports."
    )
  end

end
