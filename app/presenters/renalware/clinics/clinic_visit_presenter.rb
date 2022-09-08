# frozen_string_literal: true

require_dependency "renalware/clinics"
require_dependency "collection_presenter"

module Renalware
  module Clinics
    class ClinicVisitPresenter < DumbDelegator
      include AccountablePresentation
      
      def sanitized_notes
        ::Rails::Html::WhiteListSanitizer.new.sanitize(notes, tags: %w(p br ol li ul span div))
      end

      def height_in_cm
        return if height.blank?

        height * 100
      end
    end
  end
end
