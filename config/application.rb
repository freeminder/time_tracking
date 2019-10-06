# frozen_string_literal: true

require File.expand_path('boot', __dir__)
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TimeTracking
  # TimeTracking Rails app
  class Application < Rails::Application
    # Run "rake -D time" for a list of tasks for finding time zone names.
    config.time_zone = 'Eastern Time (US & Canada)'
    config.i18n.default_locale = :en
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :sidekiq
  end
end
