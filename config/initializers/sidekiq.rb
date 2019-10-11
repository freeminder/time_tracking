# frozen_string_literal: true

Sidekiq.default_worker_options = { backtrace: 20, retry: false }

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}" }

  schedule_file = 'config/schedule.yml'
  break unless File.exist?(schedule_file)

  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_URL']}" }
end
