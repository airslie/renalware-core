module Renalware
  module Monitoring
    module Mirth
      class IntegrationActivityQuery
        HISTORY_WEEKS = 8
        MINIMUM_COMPARISON_DAYS = 2

        SNAPSHOT_ATTRIBUTES = %i(
          received_last_hour errors_today queued_now last_report_at today_received today_sent
          today_errors typical_received comparison_days
        ).freeze
        Snapshot = Struct.new(*SNAPSHOT_ATTRIBUTES)

        def initialize(
          now: Time.zone.now,
          rows_query: IntegrationActivityRowsQuery.new,
          stats: ChannelStats.all,
          reports: StatsReport.all
        )
          @now = now
          @rows_query = rows_query
          @stats = stats
          @reports = reports
        end

        def call
          Snapshot.new(
            received_last_hour:,
            errors_today: today_rows.sum(&:errors),
            queued_now:,
            last_report_at:,
            today_received: series_for(today_rows, :received),
            today_sent: series_for(today_rows, :sent),
            today_errors: series_for(today_rows, :errors),
            typical_received:,
            comparison_days: comparison_dates.length
          )
        end

        private

        attr_reader :now, :reports, :rows_query, :stats

        def activity_rows
          @activity_rows ||= rows_query.call(from: history_starts_at, to: now)
        end

        def today_rows
          @today_rows ||= activity_rows.select { |row| row.date == now.to_date }
        end

        def received_last_hour
          last_hour_rows.sum(&:received)
        end

        def last_hour_rows
          @last_hour_rows ||= rows_query.call(from: now - 1.hour, to: now)
        end

        def queued_now = latest_stats.sum(&:queued)

        def latest_stats
          return [] unless last_report_at

          recent = stats
            .includes(:stats_report)
            .where(created_at: (last_report_at - 30.minutes)..(last_report_at + 1.second))
          recent.group_by { |stat| stat_key(stat) }.values.map { |rows| rows.max_by(&:created_at) }
        end

        def stat_key(stat)
          report = stat.stats_report
          [report&.site_id || "legacy", report&.instance_id || "legacy", stat.channel_id]
        end

        def last_report_at
          @last_report_at ||=
            [reports.maximum(:reported_at), stats.maximum(:created_at)].compact.max
        end

        def typical_received
          return {} if comparison_dates.length < MINIMUM_COMPARISON_DAYS

          (0...buckets_per_day).to_h do |bucket|
            values = comparison_dates.map do |date|
              rows_by_date_and_bucket.fetch([date, bucket], 0)
            end
            [bucket, median(values)]
          end
        end

        def comparison_dates
          @comparison_dates ||= candidate_comparison_dates.select do |date|
            activity_rows.any? { |row| row.date == date }
          end
        end

        def candidate_comparison_dates
          @candidate_comparison_dates ||= (1..HISTORY_WEEKS).map do |weeks_ago|
            now.to_date - weeks_ago.weeks
          end
        end

        def rows_by_date_and_bucket
          @rows_by_date_and_bucket ||= activity_rows.to_h do |row|
            [[row.date, row.bucket], row.received]
          end
        end

        def series_for(rows, attribute)
          rows.to_h { |row| [row.bucket, row.public_send(attribute)] }
        end

        def history_starts_at = candidate_comparison_dates.min.beginning_of_day

        def buckets_per_day = 1.day / IntegrationActivityRowsQuery::BUCKET_MINUTES.minutes

        def median(values)
          sorted = values.sort
          middle = sorted.length / 2
          return sorted[middle] if sorted.length.odd?

          (sorted[middle - 1] + sorted[middle]) / 2.0
        end
      end
    end
  end
end
