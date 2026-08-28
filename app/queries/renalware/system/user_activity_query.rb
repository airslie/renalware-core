module Renalware
  module System
    class UserActivityQuery
      BUCKET_MINUTES = 30
      HISTORY_WEEKS = 8
      MINIMUM_COMPARISON_DAYS = 2

      SNAPSHOT_ATTRIBUTES = %i(
        active_now active_today peak_count peak_bucket today typical comparison_days
      ).freeze
      Snapshot = Struct.new(*SNAPSHOT_ATTRIBUTES)

      def initialize(now: Time.zone.now, events: Event.all, users: User.all)
        @now = now
        @events = events
        @users = users
      end

      def call
        completed_today = today_counts.select { |bucket, _count| bucket < current_bucket }

        Snapshot.new(
          active_now:,
          active_today: today_scope.distinct.count(:user_id),
          peak_count: completed_today.values.max || 0,
          peak_bucket: peak_bucket(completed_today),
          today: completed_today,
          typical: typical_counts,
          comparison_days: comparison_dates.length
        )
      end

      private

      attr_reader :events, :now, :users

      def active_now
        human_users.where(last_activity_at: (now - BUCKET_MINUTES.minutes)..now).count
      end

      def action_events
        events.joins(:user).merge(human_users).where(name: "action")
      end

      def human_users
        users.where(hidden: false, banned: false).where.not(username: SystemUser.username)
      end

      def today_scope
        @today_scope ||= action_events.where(time: now.beginning_of_day..now)
      end

      def today_counts
        @today_counts ||= bucket_counts(today_scope).to_h do |bucket_time, count|
          [bucket_number(bucket_time), count]
        end
      end

      def current_bucket = bucket_number(now)

      def peak_bucket(counts) = counts.max_by { |_bucket, count| count }&.first

      def typical_counts
        return {} if comparison_dates.length < MINIMUM_COMPARISON_DAYS

        (0...buckets_per_day).to_h do |bucket|
          values = comparison_dates.map do |date|
            historical_counts.fetch([date, bucket], 0)
          end
          [bucket, median(values)]
        end
      end

      def historical_counts
        @historical_counts ||= bucket_counts(historical_scope).to_h do |bucket_time, count|
          [[bucket_time.to_date, bucket_number(bucket_time)], count]
        end
      end

      def historical_scope
        first_date = candidate_comparison_dates.min
        scope = action_events.where(time: first_date.beginning_of_day...now.beginning_of_day)
        scope.where("EXTRACT(ISODOW FROM #{local_time_sql}) = ?", now.to_date.cwday)
      end

      def comparison_dates
        @comparison_dates ||= candidate_comparison_dates.select do |date|
          historical_counts.keys.any? { |activity_date, _bucket| activity_date == date }
        end
      end

      def candidate_comparison_dates
        @candidate_comparison_dates ||= (1..HISTORY_WEEKS).map do |weeks_ago|
          now.to_date - weeks_ago.weeks
        end
      end

      def bucket_counts(scope)
        UserActivityBucketsQuery.new(scope:, bucket_minutes: BUCKET_MINUTES).call
      end

      def local_time_sql
        @local_time_sql ||= begin
          timezone = Event.connection.quote(Time.zone.tzinfo.name)
          table = Event.connection.quote_table_name(Event.table_name)
          "(#{table}.time AT TIME ZONE 'UTC' AT TIME ZONE #{timezone})"
        end
      end

      def bucket_number(time)
        ((time.hour * 60) + time.min) / BUCKET_MINUTES
      end

      def buckets_per_day = 1.day / BUCKET_MINUTES.minutes

      def median(values)
        sorted = values.sort
        middle = sorted.length / 2
        return sorted[middle] if sorted.length.odd?

        (sorted[middle - 1] + sorted[middle]) / 2.0
      end
    end
  end
end
