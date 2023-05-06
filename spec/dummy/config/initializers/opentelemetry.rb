# frozen_string_literal: true

# Set ENV var ENABLE_OPENTELEMETRY to "1" to enable opentelemetry.
# Expects there to be bundler group called opentelemetry containing all opentelemetry gems
# (opentelemetry-instrumentation-rails, opentelemetry-instrumentation-pg etc) that we need.
if ENV.fetch("ENABLE_OPENTELEMETRY", 0).to_i == 1
  Bundler.require(:opentelemetry)

  OpenTelemetry::SDK.configure do |c|
    c.service_name = "Renalware Demo"
    c.use_all # enables all instrumentation!
  end
end
