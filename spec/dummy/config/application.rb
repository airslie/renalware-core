require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
require "renalware"

module Dummy
  class Application < Rails::Application
    config.active_record.time_zone_aware_types = [:datetime]
    config.exceptions_app = Renalware::Engine.routes
    config.action_mailer.preview_path = Rails.root.join("app", "mailers", "previews")
    config.active_job.queue_adapter = :delayed_job
    config.time_zone = "London"
    config.active_record.schema_format = :sql

    initializer :add_locales do
      config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    end
  end
end
