class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "root@localhost"

  def subject_email(user_id)
    puts "hi"
  end
end