module Renalware
  module System
    class UserActivityBucketsQuery
      def initialize(scope:, bucket_minutes:)
        @scope = scope
        @bucket_minutes = bucket_minutes
      end

      def call
        scope
          .group(Arel.sql(bucket_sql))
          .pluck(Arel.sql(bucket_sql), Arel.sql("COUNT(DISTINCT #{qualified_user_id})"))
      end

      private

      attr_reader :bucket_minutes, :scope

      def bucket_sql
        @bucket_sql ||= "date_trunc('hour', #{local_time_sql}) + " \
                        "floor(EXTRACT(minute FROM #{local_time_sql}) / #{bucket_minutes}) * " \
                        "interval '#{bucket_minutes} minutes'"
      end

      def local_time_sql
        @local_time_sql ||= begin
          timezone = Event.connection.quote(Time.zone.tzinfo.name)
          "(#{qualified_time} AT TIME ZONE 'UTC' AT TIME ZONE #{timezone})"
        end
      end

      def qualified_time
        "#{quoted_table_name}.time"
      end

      def qualified_user_id
        "#{quoted_table_name}.user_id"
      end

      def quoted_table_name
        @quoted_table_name ||= Event.connection.quote_table_name(Event.table_name)
      end
    end
  end
end
