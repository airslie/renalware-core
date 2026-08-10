module Renalware
  module Monitoring
    module Mirth
      class Metrics
        include Callable

        METER_NAME = "renalware.monitoring.mirth".freeze
        LAST_REPORT_METRIC = "mirth_stats_last_report_timestamp_seconds".freeze
        CHANNEL_METRICS = {
          "mirth_channel_queued" => [
            :queued,
            "Current number of messages queued in a Mirth channel"
          ],
          "mirth_channel_received_total" => [
            :received,
            "Cumulative messages received by a Mirth channel"
          ],
          "mirth_channel_sent_total" => [:sent, "Cumulative messages sent by a Mirth channel"],
          "mirth_channel_error_total" => [:error, "Cumulative messages errored by a Mirth channel"],
          "mirth_channel_filtered_total" => [
            :filtered,
            "Cumulative messages filtered by a Mirth channel"
          ],
          "mirth_channel_state" => [
            :started_state,
            "Mirth channel state, 1 when started and 0 otherwise"
          ]
        }.freeze

        def self.enabled?
          defined?(::OpenTelemetry) && ::OpenTelemetry.respond_to?(:meter_provider)
        end

        def self.record_report(report)
          call(report:) if enabled?
        rescue StandardError => e
          Rails.logger.warn(
            "Failed to emit Mirth channel statistics OpenTelemetry metrics: " \
            "#{e.class}: #{e.message}"
          )
        end

        def initialize(report:)
          @report = report
        end

        def call
          instruments.fetch(LAST_REPORT_METRIC).record(
            report.reported_at.to_i,
            attributes: report_attributes
          )

          report.channel_stats.includes(:channel).find_each do |channel_stats|
            record_channel_stats(channel_stats)
          end
        end

        private

        attr_reader :report

        def record_channel_stats(channel_stats)
          CHANNEL_METRICS.each do |name, (attribute, _description)|
            instruments
              .fetch(name)
              .record(
                metric_value(channel_stats, attribute),
                attributes: channel_attributes(channel_stats)
              )
          end
        end

        def metric_value(channel_stats, attribute)
          return started_state_value(channel_stats) if attribute == :started_state

          channel_stats.public_send(attribute)
        end

        def started_state_value(channel_stats)
          channel_stats.state.to_s.casecmp("started").zero? ? 1 : 0
        end

        def channel_attributes(channel_stats)
          report_attributes.merge(
            "channel_id" => channel_stats.channel.uuid,
            "channel_name" => channel_stats.channel.name
          )
        end

        def report_attributes
          @report_attributes ||= {
            "site_id" => report.site_id,
            "instance_id" => report.instance_id,
            "server_id" => report.server_id.to_s
          }.compact_blank
        end

        def instruments
          self.class.instruments
        end

        class << self
          def instruments
            @instruments ||= channel_instruments.merge(
              LAST_REPORT_METRIC => meter.create_gauge(
                LAST_REPORT_METRIC,
                unit: "s",
                description: "Unix timestamp of the last Mirth statistics report received"
              )
            )
          end

          def channel_instruments
            CHANNEL_METRICS.to_h do |name, (_attribute, description)|
              [name, meter.create_gauge(name, unit: "1", description:)]
            end
          end

          def meter
            ::OpenTelemetry.meter_provider.meter(METER_NAME)
          end
        end
      end
    end
  end
end
