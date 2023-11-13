# frozen_string_literal: true

require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

require "renalware"

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.0

    config.cache_store = :file_store, Rails.root.join("tmp/cache")
    config.active_record.time_zone_aware_types = [:datetime]
    config.active_storage.service = :local
    config.autoloader = :zeitwerk
    config.active_record.belongs_to_required_by_default = false
    config.active_record.collection_cache_versioning = false

    # Important!!
    # Unless set to :all, pg extensions are not put into structure.sql so certain
    # functions will not exist.
    config.active_record.dump_schemas = :all

    unless Rails.env.development?
      config.exceptions_app = Renalware::Engine.routes
    end

    config.action_mailer.default_url_options = { host: ENV.fetch("HOST", "localhost") }
    config.time_zone = "London"
    config.active_record.schema_format = :sql
    config.active_support.escape_html_entities_in_json = false

    initializer :add_locales do
      config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
    end

    console do
      ARGV.push "-r", Renalware::Engine.root.join("config/initializers/console_prompt.rb")
    end

    # We want to start being agnostic about ActiveJob backend rather than being attached to
    # DelayedJob so am using good_job in the demo.
    # At the time of writing there are still a couple DelayedJob references in core eg using a
    # Struct for the job class in order to override the max_tries - which does not seem to be
    # possible in delayed_job when inheriting from ActiveJob::Base - but I might be wrong
    config.active_job.queue_adapter = :good_job
  end
end
