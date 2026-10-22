module Renalware
  module Monitoring
    module Mirth
      class IntegrationActivityComponent < ApplicationComponent
        CACHE_VERSION = 1
        CACHE_INTERVAL = 2.minutes
        STALE_AFTER = 45.minutes

        attr_reader :current_user, :wrapper_classes

        def initialize(
          current_user:,
          query: IntegrationActivityQuery.new,
          wrapper_classes: "columns medium-12 large-12"
        )
          @current_user = current_user
          @query = query
          @wrapper_classes = wrapper_classes
          super()
        end

        def render? = Renalware.config.monitoring_mirth_enabled

        def chart_configuration
          IntegrationActivityChart.new(snapshot:, labels: chart_labels).configuration
        end

        delegate :errors_today, :queued_now, :received_last_hour, to: :snapshot

        def chart_data? = snapshot.today_received.any?

        def comparison_description
          return t(".waiting_for_data") unless snapshot.last_report_at
          return t(".no_comparison") if snapshot.comparison_days < 2

          t(".comparison", count: snapshot.comparison_days)
        end

        def last_report_description
          return t(".never") unless snapshot.last_report_at

          t(".ago", duration: helpers.time_ago_in_words(snapshot.last_report_at))
        end

        def errors_css_class = errors_today.positive? ? "text-red-700" : "text-green-700"
        def queued_css_class = queued_now.positive? ? "text-amber-700" : "text-green-700"
        def report_css_class = report_stale? ? "text-red-700" : "text-green-700"

        private

        attr_reader :query

        def snapshot
          @snapshot ||= Rails.cache.fetch(cache_key, expires_in: 5.minutes) { query.call }
        end

        def cache_key
          [
            "mirth-integration-activity",
            CACHE_VERSION,
            Time.zone.today,
            Time.zone.now.to_i / CACHE_INTERVAL.to_i
          ]
        end

        def report_stale?
          snapshot.last_report_at.nil? || snapshot.last_report_at < STALE_AFTER.ago
        end

        def chart_labels
          {
            received: t(".received"),
            sent: t(".sent"),
            typical_received: t(".typical_received"),
            errors: t(".errors"),
            messages: t(".messages"),
            now: t(".now")
          }
        end
      end
    end
  end
end
