module Renalware
  module Monitoring
    module Mirth
      class IntegrationActivityRowsQuery
        BUCKET_MINUTES = 30
        ActivityRow = Data.define(:date, :bucket, :received, :sent, :errors)

        QUERY = <<~SQL.squish.freeze
          WITH samples AS (
            SELECT
              stats.id,
              stats.created_at AS sampled_at,
              stats.received,
              stats.sent,
              stats.error,
              LAG(stats.received) OVER (PARTITION BY %{partition} ORDER BY stats.created_at, stats.id) AS previous_received,
              LAG(stats.sent) OVER (PARTITION BY %{partition} ORDER BY stats.created_at, stats.id) AS previous_sent,
              LAG(stats.error) OVER (PARTITION BY %{partition} ORDER BY stats.created_at, stats.id) AS previous_error
            FROM %{stats_table} stats
            LEFT JOIN %{reports_table} reports ON reports.id = stats.stats_report_id
            WHERE stats.created_at >= %{history_from}
              AND stats.created_at <= %{to}
          ), deltas AS (
            SELECT
              sampled_at,
              %{received_delta} AS received,
              %{sent_delta} AS sent,
              %{error_delta} AS errors
            FROM samples
          )
          SELECT
            DATE(%{local_time}) AS activity_date,
            FLOOR(
              EXTRACT(hour FROM %{local_time}) * %{buckets_per_hour} +
              EXTRACT(minute FROM %{local_time}) / %{bucket_minutes}
            )::integer AS bucket,
            SUM(received)::bigint AS received,
            SUM(sent)::bigint AS sent,
            SUM(errors)::bigint AS errors
          FROM deltas
          WHERE sampled_at >= %{from}
          GROUP BY activity_date, bucket
          ORDER BY activity_date, bucket
        SQL

        def call(from:, to:)
          result = connection.exec_query(sql(from:, to:))
          result.map do |row|
            ActivityRow.new(
              date: Date.parse(row.fetch("activity_date").to_s),
              bucket: row.fetch("bucket").to_i,
              received: row.fetch("received").to_i,
              sent: row.fetch("sent").to_i,
              errors: row.fetch("errors").to_i
            )
          end
        end

        private

        def sql(from:, to:)
          format(QUERY, query_arguments(from:, to:))
        end

        def query_arguments(from:, to:)
          {
            partition: partition_sql,
            stats_table:,
            reports_table:,
            history_from: connection.quote(from - 1.day),
            to: connection.quote(to),
            local_time: local_time_sql,
            buckets_per_hour:,
            bucket_minutes: BUCKET_MINUTES,
            from: connection.quote(from)
          }.merge(delta_arguments)
        end

        def delta_arguments
          {
            received_delta: delta_sql(:received),
            sent_delta: delta_sql(:sent),
            error_delta: delta_sql(:error)
          }
        end

        def partition_sql
          "COALESCE(reports.site_id, 'legacy'), " \
            "COALESCE(reports.instance_id, 'legacy'), stats.channel_id"
        end

        def delta_sql(column)
          <<~SQL.squish
            CASE
              WHEN previous_#{column} IS NULL THEN 0
              WHEN #{column} >= previous_#{column} THEN #{column} - previous_#{column}
              ELSE #{column}
            END
          SQL
        end

        def local_time_sql
          @local_time_sql ||= begin
            timezone = connection.quote(Time.zone.tzinfo.name)
            "(sampled_at AT TIME ZONE 'UTC' AT TIME ZONE #{timezone})"
          end
        end

        def buckets_per_hour = 60 / BUCKET_MINUTES
        def connection = ChannelStats.connection
        def stats_table = connection.quote_table_name(ChannelStats.table_name)
        def reports_table = connection.quote_table_name(StatsReport.table_name)
      end
    end
  end
end
