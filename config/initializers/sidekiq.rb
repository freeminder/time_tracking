# frozen_string_literal: true

Sidekiq.default_worker_options = { backtrace: 20, retry: 1 }

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}" }
  config.error_handlers << proc do |ex, ctx_hash|
    return if ctx_hash[:job]["error_backtrace"].nil?

    Rails.logger.error "::: Exception: #{ex} :::"
    Rails.logger.error "::: Context hash: #{ctx_hash} :::"
    ErrorMailer.notify(ex, ctx_hash).deliver_now
  end

  schedule_file = 'config/schedule.yml'
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}" }
end
