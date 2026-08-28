module Renalware
  module Monitoring
    module Mirth
      class IntegrationActivityChart
        def initialize(snapshot:, labels:, now: Time.zone.now)
          @snapshot = snapshot
          @labels = labels
          @now = now
        end

        def configuration
          {
            chart: { height: 320, zoomType: "x" },
            credits: { enabled: false },
            time: { timezone: Time.zone.tzinfo.name },
            title: { text: nil },
            xAxis: x_axis,
            yAxis: y_axes,
            tooltip: { shared: true, xDateFormat: "%H:%M" },
            plotOptions: plot_options,
            series:
          }
        end

        private

        attr_reader :labels, :now, :snapshot

        def series
          result = [
            column_series(labels.fetch(:received), snapshot.today_received, "#2563eb"),
            column_series(labels.fetch(:sent), snapshot.today_sent, "#16a34a")
          ]
          result << typical_series if snapshot.typical_received.any?
          result << error_series
        end

        def column_series(name, values, color)
          {
            name:,
            data: points(values),
            type: "column",
            color:,
            tooltip: { valueSuffix: " messages" }
          }
        end

        def typical_series
          {
            name: labels.fetch(:typical_received),
            data: points(snapshot.typical_received),
            type: "spline",
            color: "#94a3b8",
            dashStyle: "ShortDash",
            lineWidth: 2,
            marker: { enabled: false },
            tooltip: { valueSuffix: " messages" }
          }
        end

        def error_series
          {
            name: labels.fetch(:errors),
            data: points(snapshot.today_errors),
            type: "spline",
            yAxis: 1,
            color: "#dc2626",
            lineWidth: 2,
            tooltip: { valueSuffix: " errors" }
          }
        end

        def points(values)
          values.sort.map { |bucket, value| [timestamp(time_for_bucket(bucket)), value] }
        end

        def x_axis
          {
            type: "datetime",
            min: timestamp(now.beginning_of_day),
            max: timestamp(now.tomorrow.beginning_of_day),
            tickInterval: 2.hours.in_milliseconds,
            plotLines: [now_plot_line]
          }
        end

        def y_axes
          [
            { allowDecimals: false, min: 0, title: { text: labels.fetch(:messages) } },
            {
              allowDecimals: false,
              min: 0,
              opposite: true,
              title: { text: labels.fetch(:errors) }
            }
          ]
        end

        def plot_options
          { series: { animation: false }, column: { groupPadding: 0.1, pointPadding: 0.05 } }
        end

        def time_for_bucket(bucket)
          now.beginning_of_day +
            (bucket * IntegrationActivityRowsQuery::BUCKET_MINUTES.minutes)
        end

        def timestamp(time) = time.to_i * 1000

        def now_plot_line
          {
            value: timestamp(now),
            color: "#64748b",
            dashStyle: "Dot",
            width: 1,
            label: { text: labels.fetch(:now), rotation: 0, y: 12 }
          }
        end
      end
    end
  end
end
