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
    end
  end
end
