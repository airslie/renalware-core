module Renalware
  module Monitoring
    module Mirth
      class IngestChannelStats
        include Callable

        Result = Data.define(:report, :created?)

        class InvalidPayload < StandardError
          attr_reader :errors

          def initialize(errors)
            @errors = errors
            super("Invalid Mirth channel statistics payload")
          end
        end

        def initialize(attributes:, api_credential:)
          @payload = ChannelStatsPayload.new(attributes)
          @api_credential = api_credential
        end

        def call
          raise InvalidPayload, payload.errors.to_hash unless payload.valid?

          existing_report = StatsReport.find_by(report_id: payload.report_id)
          return Result.new(report: existing_report, created?: false) if existing_report

          create_report
        rescue ActiveRecord::RecordNotUnique
          existing_report = StatsReport.find_by(report_id: payload.report_id)
          raise unless existing_report

          Result.new(report: existing_report, created?: false)
        end

        private

        attr_reader :api_credential, :payload

        def create_report
          report = StatsReport.transaction do
            StatsReport.create!(report_attributes).tap do |created_report|
              create_channel_stats!(created_report)
            end
          end

          Result.new(report:, created?: true)
        end

        def report_attributes
          {
            report_id: payload.report_id,
            reported_at: payload.reported_at_time,
            source: payload.source,
            site_id: payload.site_id,
            instance_id: payload.instance_id,
            server_id: payload.server_id.presence,
            api_credential:
          }
        end

        def create_channel_stats!(report)
          payload.channels.each do |channel_payload|
            ChannelStats.create!(channel_stats_attributes(channel_payload, report))
          end
        end

        def channel_stats_attributes(channel_payload, report)
          {
            stats_report: report,
            channel: find_or_update_channel!(channel_payload),
            state: channel_payload.state.presence,
            received: channel_payload.received.to_i,
            sent: channel_payload.sent.to_i,
            error: channel_payload.error.to_i,
            filtered: channel_payload.filtered.to_i,
            queued: channel_payload.queued.to_i,
            created_at: report.reported_at
          }
        end

        def find_or_update_channel!(channel_payload)
          Channel.find_or_initialize_by(uuid: channel_payload.id).tap do |channel|
            channel.name = channel_payload.name
            channel.save! if channel.changed?
          end
        end
      end
    end
  end
end
