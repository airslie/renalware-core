require "rubygems"
require "active_type"
require "activemodel/associations"
require "activerecord-import"
require "autoprefixer-rails"
require "chosen-rails"
require "client_side_validations"
require "client_side_validations/simple_form"
require "clipboard/rails"
require "cocoon"
require "devise"
require "delayed_job_active_record"
require "delayed_job_web"
require "dumb_delegator"
require "email_validator"
require "enumerize"
require "font-awesome-rails"
require "foundation-rails"
require "friendly_id"
require "hashdiff"
require "httparty"
require "jbuilder"
require "jquery-rails"
require "jquery-ui-rails"
require "kaminari"
require "liquid"
require "naught"
require "nested_form"
require "nokogiri"
require "paper_trail"
require "paranoia"
require "pg"
require "puma"
require "pundit"
require "ransack"
require "record_tag_helper"
require "pandoc-ruby"
require "ruby-hl7"
require "sass-rails"
require "scenic"
require "simple_form"
require "slim-rails"
require "trix"
require "underscore-rails"
require "validates_timeliness"
require "virtus"
require "wicked_pdf"
require "wisper"
require "rails-assets-foundation-datepicker"
require "rails-assets-select2"
if ENV["RAILS_ENV"] == "development"
  require "byebug"
end

module Renalware

  # Don't have prefix method return anything.
  # This will keep Rails Engine from generating all table prefixes with the engines name
  def self.table_name_prefix; end

  class Engine < ::Rails::Engine
    isolate_namespace Renalware

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/app/validators/concerns)

    config.to_prepare do
      Devise::SessionsController.layout "layouts/application"
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "../../spec/factories"
    end

    initializer :add_locales do |app|
      app.config.i18n.load_path += Dir[config.root.join("config", "locales", "**", "*.{rb,yml}")]
      app.config.i18n.default_locale = "en-GB"
      app.config.i18n.fallbacks = [:en]
    end

    initializer :assets do |app|
      app.config.assets.precompile += %w(renalware/print/pathology_request_forms.css)
      app.config.assets.precompile += %w(renalware/modernizr.js)
      app.config.assets.precompile += %w(renalware/iframeResizer.contentWindow.js)
      app.config.assets.precompile += %w(renalware/pdf.css renalware/watermark.css)
      app.config.assets.precompile += %w(renalware/protocol_pdf.css)
      app.config.assets.precompile += %w(
        renalware/NHS-Black.jpg
        renalware/favicon/manifest.json
        renalware/favicon/apple-touch-icon.png
        renalware/favicon/favicon-32x32.png
        renalware/favicon/favicon-16x16.png
        renalware/favicon/favicon.ico
        renalware/favicon/android-chrome-192x192.png
        renalware/favicon/android-chrome-512x512.png
        renalware/favicon/mstile-150x150.png
        renalware/favicon/safari-pinned-tab.svg
      )
      app.config.assets.paths <<
        Rails.root.join(config.root, "vendor", "assets", "javascripts", "renalware")
    end

    initializer :append_migrations do |app|
      # Prevent duplicate migrations if we are db:migrating at the engine level (eg when
      # running tests) rather than the host app
      running_in_dummy_app = Dir.pwd.ends_with?("dummy")
      running_outside_of_engine = app.root.to_s.match(root.to_s + File::SEPARATOR).nil?

      if running_in_dummy_app || running_outside_of_engine
        engine_migration_paths = config.paths["db/migrate"]
        app_migration_paths =  app.config.paths["db/migrate"]

        engine_migration_paths.expanded.each do |expanded_path|
          app_migration_paths << expanded_path
        end
      end
    end

    initializer :resolve_scenic_views_inside_engine do |app|
      # Set app.config.paths["db/views"] to the engine's db/views path so (out monkey-patched)
      # scenic will load views from the engine (otherwise not supported un;es manually copies in
      # a rake task, which I am keen to avoid)
      # See lib/core_extensions/scenic.rb
      view_dir = Rails.root.join(config.root, "db", "views")
      app.config.paths.add("db/views", with: view_dir)
    end

    initializer :general do |app|
      app.config.time_zone = "London"
      app.config.active_record.time_zone_aware_types = [:datetime]
      unless Rails.env.development?
        app.config.exceptions_app = Engine.routes
      end
      app.config.action_mailer.preview_path = Rails.root.join("app", "mailers", "previews")
      app.config.active_job.queue_adapter = :delayed_job
    end
  end
end
