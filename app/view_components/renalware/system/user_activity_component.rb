module Renalware
  module System
    class UserActivityComponent < ApplicationComponent
      CACHE_VERSION = 1
      CACHE_INTERVAL = 2.minutes

      attr_reader :current_user, :wrapper_classes

      def initialize(
        current_user:,
        query: UserActivityQuery.new,
        wrapper_classes: "columns medium-12 large-12"
      )
        @current_user = current_user
        @query = query
        @wrapper_classes = wrapper_classes
        super()
      end

      def chart_configuration
        {
          chart: { height: 320, type: "spline" },
          credits: { enabled: false },
          time: { timezone: Time.zone.tzinfo.name },
          title: { text: nil },
          xAxis: x_axis,
          yAxis: y_axis,
          tooltip:,
          plotOptions: plot_options,
          series:
        }
      end

      delegate :active_now, to: :snapshot
      delegate :active_today, to: :snapshot
      delegate :peak_count, to: :snapshot

      def peak_time
        return t(".not_available") unless snapshot.peak_bucket

        time_for_bucket(snapshot.peak_bucket).strftime("%H:%M")
      end

      def comparison_description
        return t(".no_comparison") if snapshot.comparison_days < 2

        t(".comparison", count: snapshot.comparison_days)
      end

      private

      attr_reader :query

      def snapshot
        @snapshot ||= Rails.cache.fetch(cache_key, expires_in: 5.minutes) { query.call }
      end

      def cache_key
        [
          "system-user-activity",
          CACHE_VERSION,
          Time.zone.today,
          Time.zone.now.to_i / CACHE_INTERVAL.to_i
        ]
      end

      def series
        result = [{ name: t(".today"), data: points(snapshot.today), color: "#2563eb" }]
        return result if snapshot.typical.empty?

        result << {
          name: t(".typical"),
          data: points(snapshot.typical),
          color: "#94a3b8",
          dashStyle: "ShortDash",
          lineWidth: 2
        }
      end

      def x_axis
        {
          type: "datetime",
          min: timestamp(Time.zone.today.beginning_of_day),
          max: timestamp(Time.zone.tomorrow.beginning_of_day),
          tickInterval: 2.hours.in_milliseconds,
          plotLines: [now_plot_line]
        }
      end

      def y_axis
        { allowDecimals: false, min: 0, title: { text: t(".active_users") } }
      end

      def tooltip
        { shared: true, xDateFormat: "%H:%M", valueSuffix: " users" }
      end

      def plot_options
        { series: { animation: false, marker: { enabled: false }, lineWidth: 3 } }
      end

      def points(counts)
        counts.sort.map { |bucket, count| [timestamp(time_for_bucket(bucket)), count] }
      end

      def time_for_bucket(bucket)
        Time.zone.today.beginning_of_day + (bucket * UserActivityQuery::BUCKET_MINUTES.minutes)
      end

      def timestamp(time)
        time.to_i * 1000
      end

      def now_plot_line
        {
          value: timestamp(Time.zone.now),
          color: "#64748b",
          dashStyle: "Dot",
          width: 1,
          label: { text: t(".now"), rotation: 0, y: 12 }
        }
      end
    end
  end
end
