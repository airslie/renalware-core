# frozen_string_literal: true

require_dependency "renalware/renal"
require "attr_extras"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      rattr_initialize :patient

      # Host application may override the order or add other summary presenters
      def summary_parts(current_user)
        Renalware
          .config
          .page_layouts[:clinical_summary]
          .map(&:constantize)
          .map { |klass| klass.new(patient, current_user) }
          .select(&:render?)
      end
    end
  end
end
