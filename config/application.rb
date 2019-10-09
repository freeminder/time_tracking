# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TimeTracking
  # TimeTracking Rails app
  class Application < Rails::Application
    config.load_defaults '6.0'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.i18n.default_locale = :en
    config.active_job.queue_adapter = :sidekiq
  end
end
