# frozen_string_literal: true

require_dependency "renalware/renal"
require "attr_extras"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      rattr_initialize :patient

      # Host application may override the order or add other summary presenters
      def summary_parts
        Renalware.config.page_layouts[:clinical_summary].map(&:constantize)
      end
    end
  end
end
