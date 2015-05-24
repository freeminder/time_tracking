require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DPITimeTracking
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    config.active_job.queue_adapter = :delayed_job

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        value = value.to_json if value.kind_of? Hash
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    # Mail config
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
    :address => "localhost",
    :port => 25,
    # :domain => "gmail.com",
    # :authentication => 'plain',
    :enable_starttls_auto => false,
    # :user_name => "youremail@gmail.com",
    # :password => "yourpassword"
    }
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true


  end
end
