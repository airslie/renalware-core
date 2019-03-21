# frozen_string_literal: true

require_dependency "renalware/clinics"
require_dependency "collection_presenter"

module Renalware
  module Clinics
    class ClinicVisitPresenter < DumbDelegator
      def sanitized_notes
        ::Rails::Html::WhiteListSanitizer.new.sanitize(notes, tags: %w(p br ol li ul span div))
      end
    end
  end
end
