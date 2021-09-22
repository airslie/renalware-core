# frozen_string_literal: true

require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)
require "renalware"
require "view_component/engine"

module Dummy
  class Application < Rails::Application
    config.cache_store = :file_store, Rails.root.join("tmp/cache") # capistrano symmlinked
    config.active_record.time_zone_aware_types = [:datetime]
    config.active_storage.service = :local
    config.autoloader = :classic
    # config.autoloader = :zeitwerk

    # Important!!
    # Unless set to :all, pg extensions are not put into structure.sql so certain
    # functions will not exist.
    config.active_record.dump_schemas = :all

    unless Rails.env.development?
      config.exceptions_app = Renalware::Engine.routes
    end

    config.action_mailer.default_url_options = { host: ENV.fetch("HOST", "localhost") }
    config.active_job.queue_adapter = :delayed_job
    config.time_zone = "London"
    config.active_record.schema_format = :sql
    config.active_support.escape_html_entities_in_json = false

    initializer :add_locales do
      config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
    end

    config.assets.css_compressor = Tailwindcss::Compressor.new(
      files_with_class_names:
      [
        Rails.root.glob("../../app/**/*.slim"),
        Rails.root.glob("../../app/**/*.erb"),
        Rails.root.glob("../../app/**/*.rb"),
        Rails.root.glob("../../app/javascript/**/*.js")
      ].flatten.uniq
    )
  end
end
