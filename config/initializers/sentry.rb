# frozen_string_literal: true

require "sentry-rails"
require "sentry-ruby"

Sentry.init do |config|
  config.dsn = Renalware.config.sentry_dsn
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = Renalware.config.sentry_sample_rate
end
