# rubocop:disable Lint/HandleExceptions
require_relative "boot"
require "rails"

# Skip test_unit and action_cable
%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie.to_s
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Renalware
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    config.active_record.time_zone_aware_types = [:datetime]

    config.exceptions_app = routes

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]

    config.i18n.default_locale = "en-GB"
    config.i18n.fallbacks = [:en]

    config.active_record.schema_format = :sql

    config.action_mailer.preview_path = Rails.root.join("app", "mailers", "previews")

    config.autoload_paths += %W(
      #{config.root}/app/validators/concerns
    )

    config.assets.paths << Rails.root.join("vendor", "assets", "fonts")

    config.active_job.queue_adapter = :delayed_job
  end
end
