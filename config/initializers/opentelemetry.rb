# Set ENV var ENABLE_OPENTELEMETRY to "1" to enable opentelemetry.
# Expects there to be bundler group called opentelemetry containing all opentelemetry gems
# (opentelemetry-instrumentation-rails, opentelemetry-instrumentation-pg etc) that we need.
if !Rails.env.test? && ENV.fetch("ENABLE_OPENTELEMETRY", 0).to_i == 1
  require Rails.root.join("app/services/open_telemetry_error_subscriber")
  require "opentelemetry-metrics-sdk"
  require "opentelemetry-exporter-otlp-metrics"

  # The metrics SDK can auto-register an OTLP exporter from OTEL_METRICS_EXPORTER.
  # We add one explicit reader below so the app does not double-export metrics when
  # Azure App Service sidecar settings include OTEL_METRICS_EXPORTER=otlp.
  ENV["OTEL_METRICS_EXPORTER"] = "none"

  OpenTelemetry::SDK.configure do |c|
    c.service_name = ENV.fetch("OTEL_SERVICE_NAME", "renalware")
    c.use_all

    # Ensure exporting async and limit memory growth under back-pressure.
    c.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
        OpenTelemetry::Exporter::OTLP::Exporter.new,
        schedule_delay: 5_000, # ms
        max_queue_size: 2048,
        max_export_batch_size: 512
      )
    )
  end

  metric_exporter = OpenTelemetry::Exporter::OTLP::Metrics::MetricsExporter.new
  metric_reader = OpenTelemetry::SDK::Metrics::Export::PeriodicMetricReader.new(
    exporter: metric_exporter
  )
  OpenTelemetry.meter_provider.add_metric_reader(metric_reader)

  Rails.error.subscribe(OpenTelemetryErrorSubscriber.new)
end
