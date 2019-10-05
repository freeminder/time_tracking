# frozen_string_literal: true

# Error mailer
class ErrorMailer < ActionMailer::Base
  def notify(exn, ctx_hash)
    mail(
      from: ENV['EMAIL_FROM'],
      to: ENV['EMAIL_ADMIN'],
      subject: 'Error from worker',
      body: "Exception: #{exn}. \nContext hash: #{ctx_hash}."
    )
  end
end
