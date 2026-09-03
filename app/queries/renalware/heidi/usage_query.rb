module Renalware
  module Heidi
    class UsageQuery
      DEFAULT_MONTHS = 12
      MONTH_OPTIONS = [12, 24, 36, 60].freeze
      MAX_MONTHS = 120

      Month = Struct.new(:month, :distinct_user_count, :session_count)

      def self.month_options(selected_months)
        (MONTH_OPTIONS | [selected_months]).sort
      end

      def initialize(months: DEFAULT_MONTHS)
        @months = Integer(months.presence || DEFAULT_MONTHS).clamp(1, MAX_MONTHS)
      rescue ArgumentError
        @months = DEFAULT_MONTHS
      end

      attr_reader :months

      def call
        aggregate_counts = counts_by_month

        month_starts.map do |month|
          counts = aggregate_counts.fetch(month, {})
          Month.new(
            month,
            counts.fetch(:distinct_user_count, 0),
            counts.fetch(:session_count, 0)
          )
        end
      end

      private

      def counts_by_month
        count_rows.each_with_object({}) do |(month, distinct_user_count, session_count), hash|
          hash[month.to_date] = { distinct_user_count:, session_count: }
        end
      end

      def count_rows
        Session
          .where(created_at: start_month..)
          .where.not(heidi_session_id: [nil, ""])
          .group(month_expression)
          .pluck(
            month_expression,
            Arel.sql("COUNT(DISTINCT user_id)"),
            Arel.sql("COUNT(*)")
          )
      end

      def month_starts
        (0...months).map { |offset| offset.months.ago.beginning_of_month.to_date }
      end

      def start_month
        (months - 1).months.ago.beginning_of_month
      end

      def month_expression
        Arel.sql("DATE_TRUNC('month', #{Session.quoted_table_name}.created_at)")
      end
    end
  end
end
