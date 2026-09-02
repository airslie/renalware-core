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
        heidi_status&.humanize
      end

      def heidi_status
        latest_heidi_session&.status
      end

      def heidi_state_css_class
        return if heidi_status.blank?

        "heidi-state--#{heidi_status.dasherize}"
      end

      private

      def latest_heidi_session
        heidi_sessions.max_by(&:created_at)
      end
    end
  end
end
