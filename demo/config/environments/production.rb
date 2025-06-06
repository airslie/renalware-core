Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.good_job.execution_mode = :async

  # On production then this is the demo site e.g.
  #   HEROKU_APP_URL=renalware-demo.herokuapp.com
  #   HEROKU_CUSTOM_DOMAIN=demo.renalware.app
  # so redirect requests on renalware-demo.herokuapp.com to demo.renalware.app
  # because even though we have added a custom domain to Heroku, the original herokuapp
  # url remains available and this can be confusing. Also, mailgun email will probably
  # only work on the custom domain.
  if ENV.fetch("HEROKU_APP_URL", nil) && ENV.fetch("HEROKU_CUSTOM_DOMAIN", nil)
    config.middleware.use Rack::HostRedirect, {
      ENV.fetch("HEROKU_APP_URL", nil) => ENV.fetch("HEROKU_CUSTOM_DOMAIN", nil)
    }
  end

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :terser
  # Added this to prevent sassc-rails error in tailwindcss-generated css
  # 'Error: Function rgb is missing argument $green'
  # >>   border-color: rgb(229 231 235 / var(--tw-border-opacity));
  # The sassc-rails gem is automatically used for CSS compression if included in
  # the Gemfile and no config.assets.css_compressor option is set.
  config.assets.css_compressor = nil

  # ActionMailer::Base.smtp_settings = {
  #   address: "smtp.sendgrid.net",
  #   port: "587",
  #   authentication: :plain,
  #   user_name: ENV["SENDGRID_USERNAME"],
  #   password: ENV["SENDGRID_PASSWORD"],
  #   domain: "heroku.com",
  #   enable_starttls_auto: true
  # }
  ActionMailer::Base.smtp_settings = {
    port: ENV.fetch("MAILGUN_SMTP_PORT", nil),
    address: ENV.fetch("MAILGUN_SMTP_SERVER", nil),
    user_name: ENV.fetch("MAILGUN_SMTP_LOGIN", nil),
    password: ENV.fetch("MAILGUN_SMTP_PASSWORD", nil),
    domain: ENV.fetch("HEROKU_CUSTOM_DOMAIN", nil),
    authentication: :plain
  }
  ActionMailer::Base.delivery_method = :smtp

  # .
  # Important for Devise redirects to and from login page.
  config.relative_url_root = ENV.fetch("RAILS_RELATIVE_URL_ROOT", "/")

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have
  # moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = ENV["HEROKU"].present?

  # if defined?(PartyFoul)
  #   config.middleware.use(PartyFoul::Middleware)
  # end

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  config.cache_store = :solid_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_name_prefix = "renalware_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = [I18n.default_locale]

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
