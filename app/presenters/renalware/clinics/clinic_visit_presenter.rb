module Renalware
  module Clinics
    class ClinicVisitPresenter < DumbDelegator
      NOTE_TAGS = %w(p br ol li ul span div strong em).freeze

      def sanitized_notes
        ::Rails::Html::WhiteListSanitizer.new.sanitize(
          notes,
          tags: NOTE_TAGS
        )
      end

      def height_in_cm
        return if height.blank?

        height * 100
      end

      def heidi_state
        latest_heidi_session&.status&.humanize
      end

      def heidi_state_css_class
        return if latest_heidi_session.blank?

        "heidi-state--#{latest_heidi_session.status.dasherize}"
      end

      def heidi_state_icon
        {
          "launched" => nil,
          "synced" => "check-circle",
          "sync_failed" => "cross"
        }.fetch(latest_heidi_session&.status, nil)
      end

      private

      def latest_heidi_session
        heidi_sessions.max_by(&:created_at)
      end
    end
  end
end
